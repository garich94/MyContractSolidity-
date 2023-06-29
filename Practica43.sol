// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Number {
    uint8 public num;

    function numPlus() public {
        // 22623
        
        num += 5;
           
        require( num < 255, "OverFloy!");
    }
}