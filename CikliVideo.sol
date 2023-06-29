// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Demo {
    uint[] public arr;

    function demo() public {
        for(uint i = 0; i < 10; i++) {
            if(i == 5) {
                continue;
            }
            arr.push(i);
        }
    }
}