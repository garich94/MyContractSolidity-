// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract ConstantNumber {    
  uint public commission;
  constructor (uint _commission) { 
     commission = _commission;
 }
}