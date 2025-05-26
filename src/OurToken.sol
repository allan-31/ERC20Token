// SPDX-License-Identifier: MIT

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

pragma solidity ^0.8.2;

/// @title A sample ERC20 token contract
/// @author Arinaitwe Allan
/// @notice This contract implements a simple ERC20 token
/// @dev This contract is used to demonstrate the basic functionality of an ERC20 token

contract OurToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("Our Token", "OT") {
        _mint(msg.sender, initialSupply);
    }
}
