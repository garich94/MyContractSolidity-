// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Ownable {
    address owner;

    constructor(address _owner) {
        owner = _owner;
    }

    modifier onlyOwner() {
        require(msg.sender == getOwner(), "Not an owner");
        _;
    }

    function getOwner() public view returns(address) {
        return owner;
    }
}

abstract contract UserSaver is Ownable {
    mapping(address => string) users;

    function receiveUser(address _addr, string memory _name) public virtual {
        saveUser(_addr, _name);
    }

    function saveUser(address _addr, string memory _name) internal {
        users[_addr] = _name;
    }

    function getUserName(address _addr) public view onlyOwner returns(string memory) {
        return users[_addr];
    }
}

contract UserStorage is Ownable, UserSaver {
    constructor() Ownable(msg.sender) {}
    function receiveUser(address _addr, string memory _name) public override {
        super.receiveUser(_addr, _name);
        emit UserStored(_addr, _name);
    }

    event UserStored(address _addr, string _name);
}

