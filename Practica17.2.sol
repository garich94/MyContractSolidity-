// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract BytesStorage {    
    bytes1 public small;
    bytes32 public large;
    bytes public str = unicode"Это было не сложно";
}