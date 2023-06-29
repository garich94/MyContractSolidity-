// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Calldate {
    function calldate(uint[] calldata _arr) public pure returns(uint) {
        //948 gas с calldate 2028 gas с memory
        return _arr[0] * 2;
    }
}