// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract TypeStorage {
    uint[] public arr; //storage

    function demo() public pure returns(uint[] memory) {
        uint[] memory newArr = new uint[](3);
        newArr[0] = 42;
        newArr[1] = 100;
        newArr[2] = 200;
        return newArr;
    }
}