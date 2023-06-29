//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract VarDemo {
    uint public myVar; // объявление новой переменной 

    function setMyVar(uint _newValue) public {
        myVar = _newValue;
    }
}