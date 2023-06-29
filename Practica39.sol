// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract First {
    function sendeMoney(address payable _to) public payable {
        _to.transfer(msg.value);
    }
}