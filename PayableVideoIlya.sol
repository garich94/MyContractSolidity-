// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Payable {
    uint public total;

    function pay() public payable {
        total += msg.value;
    }
}