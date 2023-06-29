// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract SumItUp {    
  int balance = 4500 ;
  int commission = -10;
	
  function sum() view public returns (int){
    int total = balance + commission;		
    return total;
  }
}