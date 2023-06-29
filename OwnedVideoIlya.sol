// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Owned {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Not an owner!");
        _;
    }

    function parentFunc() public virtual pure returns(uint) {
        return 42;
    }
}