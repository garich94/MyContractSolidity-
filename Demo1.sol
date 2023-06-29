// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Demo {
    address public sender;

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function pay() external payable {
        sender = msg.sender;
    }
}