// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Sample {
    uint[10][3] public items;
    uint public myVal;
    // items = [
        // [0, 1, 2, 3, ...]
        // []
        // [] 
    // ]
    
    string[5] public strings;
    uint public myLength;

    function demo() public {
        // 0 - 9 индексы массива с 10 элементами
        items[0][2] = 200;
        myVal = items[0][2];
    }
}