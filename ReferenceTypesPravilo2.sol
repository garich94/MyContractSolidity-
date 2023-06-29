// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Demo {
    uint[] public stateArr;

    function pravilo2(uint[] memory mArr) public returns(uint[] memory) {
        stateArr = mArr;
        mArr[0] = 42;
    }
}