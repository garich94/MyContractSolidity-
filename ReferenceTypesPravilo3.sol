// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Demo {
    uint[] public stateArr;

    function pravilo3() public {
        stateArr = [1, 2, 3];
        uint[] storage localStorageArr = stateArr;

        localStorageArr[0] = 42;
    }
}