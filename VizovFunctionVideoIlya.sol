// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Other {
    function callGetName(address _demoAddr) public view returns (string memory) {
        return Demo(_demoAddr).getName();
    }
}

contract Demo {
    string name = "John";
    function getName() external view returns (string memory) {
        return name;
    }
}