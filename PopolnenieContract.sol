// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FundsDemo {
    uint public balanceReceived;

    function receiveMoney() public payable {
        balanceReceived += msg.value;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
