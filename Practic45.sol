// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Overflow {
    uint8 public newNum;

    modifier numProverka(uint8 _num) {
        require(_num + 5 < 255, "Overflow!");
        _;
    }

    function counter(uint8 _num) public numProverka(_num) returns(uint) {
        newNum = _num + 5;
        return newNum;
    }
}