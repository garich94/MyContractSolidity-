// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract AddressDemo {
    address myAddress;

    function setAddress(address _newAddr) public {
        myAddress = _newAddr;
    }

    function getBalance() public view returns (uint) {
        return myAddress.balance;
    }
}