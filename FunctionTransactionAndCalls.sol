// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract FunctionsDemo {
    address public owner;
    mapping(address => uint) public balanceReceived;

    function withdrawMoney(address payable _to, uint _amount) public {
        balanceReceived[msg.sender] -= _amount;
        _to.transfer(_amount);
    }

    function getOwner() public view returns(address) {
        return owner;
    }
}