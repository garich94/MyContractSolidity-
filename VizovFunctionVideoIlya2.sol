// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Other {
    function payDemo(Demo _demo) public payable {
        _demo.pay{value: msg.value}(msg.sender);
    }
}

contract Demo {
    mapping(address => uint) public payments;

    function pay(address _payer) public payable {
        payments[_payer] = msg.value;
    }
}