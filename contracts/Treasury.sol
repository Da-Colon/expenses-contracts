// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";

contract TreasuryContract is AccessControlUpgradeable {
  using SafeMathUpgradeable for uint256;

  bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
  bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
  bytes32 public constant EMPLOYEE_ROLE = keccak256("EMPLOYEE_ROLE");

  struct Treasury {
    address id;
    bool active;
    uint128 manager_rewards_bp;
    uint128 employee_rewards_bp;
    address[] managers;
  }

  // define structs
  struct Employee {
    address id;
    uint256 balance;
    uint256 monthly_allowance;
    uint256 rewards_total;
  }

  struct Manager {
    address id;
    address treasury;
    uint256 balance;
    uint256 quarterly_allowance;
    uint256 rewards_total;
    address[] employees;
  }

  modifier treasuryIsActive {
    require(
      treasuries[msg.sender].active == true,
      'Treasury is closed'
    );
    _;
  }

  // define state variables
  mapping(address => Manager) managers;
  mapping(address => Employee) employees;
  mapping(address => Treasury) treasuries;

  function createTreasury(uint128 managerBP, uint128 employeBP) public {
    address _account = msg.sender;
    treasuries[_account] = Treasury({
      active: true,
      id: _account,
      manager_rewards_bp: managerBP,
      employee_rewards_bp: employeBP,
      managers: new address[](0)
    });
    _setupRole(ADMIN_ROLE, _account);
  }

  function closeTreasury() public treasuryIsActive {
    require(
      hasRole(ADMIN_ROLE, msg.sender), 
      'Restricted Admin Only'
      );
    treasuries[msg.sender].active = false;
  }

  function updateManagerBP(uint128 bp) public treasuryIsActive {
    require(
      hasRole(ADMIN_ROLE, msg.sender), 
      'Restricted Admin Only'
      );
    treasuries[msg.sender].manager_rewards_bp = bp;
  }

  function updateEmployeeBP(uint128 bp) public treasuryIsActive {
    require(
      hasRole(ADMIN_ROLE, msg.sender), 
      'Restricted Admin Only'
      );
    treasuries[msg.sender].employee_rewards_bp = bp;
  }

  function quarterlyBalanceRefresh(address payable recipient) public payable treasuryIsActive {
    address _account = msg.sender;
    uint256 difference = managers[recipient].quarterly_allowance.sub(managers[recipient].balance);
    require(
      hasRole(ADMIN_ROLE, _account), 
      'Restricted Admin Only'
      );
    require(
      difference >= 0, 
      'No deposit needed'
      );
    require(
      _account.balance < difference, 
      'Not enought funds to transfer'
      );
    require(
      managers[recipient].id == recipient, 
      'Manager does not exist'
      );

    recipient.transfer(difference);
    managers[recipient].rewards_total += managers[recipient].balance.mul(treasuries[_account].manager_rewards_bp).div(10**3);
    managers[recipient].balance += difference;
  }

  function createManager(address newManager, uint256 allowance) public treasuryIsActive {
    require(
      hasRole(ADMIN_ROLE, msg.sender), 
      'Restricted Admin Only'
      );
    address _account = msg.sender;

    treasuries[_account].managers.push(newManager);

    managers[newManager] = Manager({
      id: newManager,
      employees: new address[](0),
      treasury: _account,
      balance: allowance,
      quarterly_allowance: allowance,
      rewards_total: 0
    });
  }

  function createEmployee(address newEmployee, uint256 allowance) public {
    address _account = msg.sender;
    require(
      hasRole(MANAGER_ROLE, _account), 
      'Restricted Admin Only'
      );
    require(
      treasuries[managers[_account].treasury].active == true,
      'Treasury is closed'
      );

    managers[_account].employees.push(newEmployee);

    employees[newEmployee] = Employee({
      id: newEmployee,
      balance: allowance,
      monthly_allowance: allowance,
      rewards_total: 0
    });
  }
  
}