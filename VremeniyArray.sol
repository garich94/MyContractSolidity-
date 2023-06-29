// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Sample {
    uint[][3] public items;
    uint public myLength;

    function demo() public {
        uint[] memory items = new uint[](7);
        myLength = items.length;
    }
}