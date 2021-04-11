// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract EpicBadTiming is ERC20 {
    constructor() ERC20("EpicBadTiming", "EBT") {
      _mint(msg.sender, 100 * 10**6 * 10**18);
    }
}