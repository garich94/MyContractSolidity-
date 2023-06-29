// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Demo {
    uint myInt = 42;
    uint[] arr;

    //transaction
    function add(uint _num) public {
        arr.push(_num);
    }

    //call
    function get(uint _index) public view returns(uint) {
        return arr[_index] * 2;
    }

    function demo(uint _km) public pure returns(uint) {
        return _km * 2;
    }
}