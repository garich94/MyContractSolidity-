// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Demo {
    address public owner;
    uint public total;

    constructor() {
        owner = msg.sender;
    }

    function getMoney() public payable {
        total += msg.value;
    }

    function totalEth() public view returns(uint) {
        return total / 10 ** 18;
    }

    receive() external payable {
        getMoney();
    }

    fallback() external payable {
        //..
    }
}