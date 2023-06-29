//SPDX-License-Identifier: GPL-3.0 
pragma solidity ^0.8.0;

contract MappingsNames {
      mapping(uint => string) public nameList;

      function addNames(uint _number, string memory _name) public {
        nameList[_number] = _name;
      }
}