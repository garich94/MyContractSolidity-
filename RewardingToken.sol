// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC20.sol";

contract RewardingToken is ERC20 {
    constructor() ERC20("Rewarding", "RW", 10000) {}
}