// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract LogicPeremen {
    bool myVar = false;

    function demo() public {
        myVar && true;
        myVar || false;
        !myVar;
        if(myVar || true){}
    }
}