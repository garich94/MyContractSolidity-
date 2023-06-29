// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract TopParent {
    string public name;

    constructor(string memory _name) {
        name = _name;
    }
}

contract Owned {
    address public owner;

    constructor(address _addr) {
        owner = _addr;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Not an owner!");
        _;
    }
}