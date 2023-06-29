// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract C2 {
    function demo() external view returns(uint){
        uint result;
        assembly {
            let a := 1 // в Yul объявление переменной 
            let b := mul(a, 2) // умножение в Yul
            result := add(a, b) //сложение 
        }

        return result;
    }
}