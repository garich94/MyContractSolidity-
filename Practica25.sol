//SPDX-License-Identifier: GPL-3.0 
pragma solidity ^0.8.0;

contract MyContract {
  string[] public myList = ['John','Mary', 'Sasha', 'Rose', 'Elvis'];

  function getValue(uint _index) public view returns (string memory) {
    return myList[_index];
  }
}