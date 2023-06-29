// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract MappingDemo {
    mapping(address => bool) public addrMap;

    function addAddress() public {
        addrMap[msg.sender] = true;
    }
}