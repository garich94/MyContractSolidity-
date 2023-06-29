// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract newUnchaked {
    //87335 gas 
    function plus(uint x, uint y) external pure returns (uint) {
         unchecked {
             return x + y;
        }    
    }
}