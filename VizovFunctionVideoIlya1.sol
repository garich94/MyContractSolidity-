// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Other {
    function callSetName(Demo _demo, string calldata _name) public {
        _demo.setName(_name);
    }
}

contract Demo {
    string public name = "John";

    function setName(string calldata _newName) external {
        name = _newName;
    }
}

