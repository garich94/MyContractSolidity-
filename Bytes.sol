// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Sample {
    bytes public myVar = "test";
    bytes32 public myVar32;
    uint public myLength;
    string public str = unicode"test это текст";
    bytes1 public char;

    function demo() public {
        myLength = myVar.length;
        char = myVar[0];
    }
}