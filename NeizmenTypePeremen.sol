// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Demo {
    address public immutable owner;

    constructor(address _newOwner) { //2566 gas //430 gas
        owner = _newOwner;
    }

    function demo() public view returns(uint) {
        require(msg.sender == owner, "");
        return 42;
    }
}