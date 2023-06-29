// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Demo {
    /*function demo() public pure returns(string memory, uint) {
        return("test", 52);
    }*/

    function demo() public pure returns(string memory _myStr, uint _myInt) {
        _myStr = "test";
        _myInt = 52;
    }

    function caller() public pure returns(uint) {
        (, uint _myInt) = demo();
        return _myInt;
    }
}