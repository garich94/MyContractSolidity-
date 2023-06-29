// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract C2 {
    uint8[2] test = [4, 5];
    uint8[2] test2 = [5, 100];

    // uint8 public test = 42; // так как размер переменных по 32 байта(256бит) занимать она будет целый слот. номер слота 0 
    // uint8 test2 = 100; // номера слота 1


    function demo() external view returns(bytes32 slot0, bytes32 slot1) {

        assembly {
            //sstore(0, 0x20) //заменяем значение в любой слот нашего кода, главное знать номер слота 
            slot0 := sload(0) // читаем значение слота
            slot1 := sload(1)
        }

    }
}