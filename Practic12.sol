// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract TestStrings {
  string public errorMessage = "Sorry, your transaction failed.";
  string constant public SUCCESSMSG = "Transaction successful!";
  string public currentStatus;
	
  function changeStatus(string memory _currentStatus) public {
    currentStatus = _currentStatus;  
  }
}