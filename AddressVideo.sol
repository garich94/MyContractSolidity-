// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Sample {
    address myAddr = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
    uint public myBalance;

    function demo() public {
        myBalance = myAddr.balance;
    }
}