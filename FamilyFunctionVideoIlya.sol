// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Owned.sol";

contract Demo is Owned {
    function parentFunc() public override pure returns(uint) {
        uint parentResult = super.parentFunc();

        return parentResult * 2;
    }
}