// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract CheckEquality {
    bool public result;

    function isEqual(int _firstNum, int _secondNum) public {
        result = _firstNum >= _secondNum;
    }
} 