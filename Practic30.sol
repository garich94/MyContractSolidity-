// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.1;

contract First {
  function sendMoney(address payable _to) public payable {
    _to.transfer(msg.value);
  } 
}

contract Second {
  receive() external payable {}

  fallback() external payable {}

  function getBalance() public view returns(uint) {
      return address(this).balance;
  }
}

contract Third {
    receive() external payable {}

  fallback() external payable {}

  function getBalance() public view returns(uint) {
      return address(this).balance;
  }
} 