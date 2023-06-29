// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract IterMapping {
    mapping(string => uint) public ages;
    string[] public keys;
    mapping(string => bool) public isInserted;

    function set(string memory _name, uint _age) public {
        ages[_name] = _age;

        if(!isInserted[_name]) {
            isInserted[_name] = true;
            keys.push(_name);
        }
    }

    function length() public view returns(uint) {
        return keys.length;
    }

    function get(uint _index) public view returns(uint) {
        string memory key = keys[_index];
        return ages[key];
    }

    function values() public view returns(uint[] memory) {
        uint[] memory vals = new uint[](keys.length);

        for(uint i = 0; i < keys.length; i++) {
            vals[i] = ages[keys[i]];
        }

        return vals;
    }
}