// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Teller {    
  uint public bal;
	
  function setBalance(address _addr) public {
    bal = _addr.balance;
  }
}