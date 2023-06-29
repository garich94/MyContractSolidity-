// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IDemo {
    function getName() external view returns (string memory);
}

contract Other {
    function callDemo(IDemo _demo) public view returns(string memory) {
        return _demo.getName();
    }
}