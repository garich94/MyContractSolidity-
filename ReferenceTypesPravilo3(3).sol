// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Demo {
    uint[] public stateArr;

    function pravilo333() public {
        stateArr = [1, 2, 3];
        uint[] storage localStorageArr = stateArr;

        localStorageArr[0] = 42;

        otherFunc(localStorageArr);
    }

    function otherFunc(uint[] memory sArr) internal {
        sArr[1] = 100;
    } 
}