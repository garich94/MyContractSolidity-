// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract CelieChisla {
    uint8 public myVar = 255;

    function demo() public {
        unchecked {
            myVar++;
        }
    }  
}