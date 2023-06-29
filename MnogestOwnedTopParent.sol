// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract TopParent {
      function parentFunc() public virtual pure returns(uint) {
        return 1;
    }
}

contract Owned is TopParent {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Not an owner!");
        _;
    }

    function parentFunc() public virtual override pure returns(uint) {
        return 42;
    }
}