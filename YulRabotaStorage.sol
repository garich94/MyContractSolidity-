// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract C2 {
    function demo() external view returns(bytes32 s) {
        uint test = 42; 

        assembly {
            let freeMemoryPointer := mload(0x40) // означает загрузить, что-то из памяти
            s := mload(sub(freeMemoryPointer, 0x20)) // sub вычитание
        }
    }

}