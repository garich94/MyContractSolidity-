// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Demo {
    function demo() public view returns(uint[] memory) {
        //reference types
        uint[] memory a = new uint[](3);
        a[0] = 1;

        uint[]memory b = new uint[](3);
        b = a;

        b[1] = 42;
        return a ;
    }
}