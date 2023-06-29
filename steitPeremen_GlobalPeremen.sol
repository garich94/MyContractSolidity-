//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Demo {
    uint public sum;
    address public sender;
    uint public timestamp;
    uint public number;
    uint public limit;
    uint public price;
    address public contractAddr;
    uint public balance;

    function demo() public payable {
        sum = msg.value;
        sender = msg.sender; 
        timestamp = block.timestamp;
        number = block.number;
        limit = block.gaslimit;
        price = tx.gasprice;
        contractAddr = address(this);
        balance = contractAddr.balance;
    }
}