// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Sample {
    uint[][3] public items;
  

    function demo() public {
        items[0] = [1, 2, 3];
        items[0].push(4);
    }
}