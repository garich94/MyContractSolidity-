//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Converter {
  string[] public units = ["Finney", "Gwei", "Wei"];

  function demo(uint _kolETH, uint _index) public pure returns(uint) {
       if (_index == 0) {
          return _kolETH * 10 ** 3;
       } else if (_index == 1) {
          return _kolETH * 10 ** 9;
       } else if (_index == 2) {
          return _kolETH * 10 ** 25;
       } else {
          _kolETH;
       }
  }
    
} 