// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// TODO look up what this does
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract Expenses is Initializable {
  // define structs
  struct employee {
    address id;
    uint monthly_allowance;
    address manager;
  }

  struct manager {
    address id;
    uint256 quarterly_allowance;
  }

  // define state variables
  IERC20 private EpicBadTimingToken;
  uint256 currentTotalAllowance;
  address admin;
  mapping(address => manager) managers;
  mapping(address => employee) employees;
  mapping(address => uint256) allowance;


  // define state at compile
  constructor() {
    admin = msg.sender;
  }

  // define events
  event Initializing(address);

  // define modifiers
  modifier restrictedAdmin() {
    require(
      msg.sender == admin,
      "Access restricted to admin"
    );
    _;
  }

  modifier restrictedManager() {
    require(
      msg.sender == managers[msg.sender].id,
      "Access restricted to manager"
    );
    _;
  }

  modifier restrictedEmployee() {
    require(
      msg.sender == employees[msg.sender].id,
      "Access restricted to employee"
    );
    _;
  }

  // define methods

  // initializes ERC20 token in contract
  function initialize(address _epicBadTimingToken) public initializer {
      EpicBadTimingToken = IERC20(_epicBadTimingToken);
      emit Initializing(_epicBadTimingToken);
  }


  // ! admin restricted methods (this could be changed to be updated by the dao)

  // add manager
  function addManager(address _newManagerAddress, uint256 _quarterly_allowance) restrictedAdmin public {
    manager memory newManager = manager({
      id: _newManagerAddress,
      quarterly_allowance: _quarterly_allowance
    });

    managers[_newManagerAddress] = newManager;
  }
  // update manager (quartly_allowance)
  function updateQuarterlyAllowance(address _managerAddress, uint256 _quarterly_allowance) restrictedAdmin public {
    require(managers[_managerAddress].id == _managerAddress, 'Manager does not exist');
    managers[_managerAddress].quarterly_allowance = _quarterly_allowance;
  }
  // remove manager
  function removeManager(address _managerAddress) restrictedAdmin public {
    require(managers[_managerAddress].id == _managerAddress, 'Manager does not exist');
    delete managers[_managerAddress];
  }
  
  // ! manager  restricted methods
  
  // add employee
  function addEmployee(address _newEmployeeAddress, uint256 _monthly_allowance) restrictedManager public {
    employee memory newEmployee = employee({
      id: _newEmployeeAddress,
      monthly_allowance: _monthly_allowance,
      manager: msg.sender
    });

    employees[_newEmployeeAddress] = newEmployee;
  }

  // update employee (monthly_balance)
  function updateMonthlyAllowance(address _employeeAddress, uint256 _monthly_allowance) restrictedManager public {
    require(employees[_employeeAddress].id == _employeeAddress, 'Employee does not exist');
    employees[_employeeAddress].monthly_allowance = _monthly_allowance;
  }

  // ! employee restricted methods

  // claim amount out of allowance
  function claimAllowance(uint256 _amount) restrictedEmployee public view {
    require(_amount >= allowance[msg.sender], 'Not enough allowance to withdraw');
  }
  // // ! getter methods
  // function employeeInformation() public view returns(uint) {

  // }

  // ! interal methods
}


