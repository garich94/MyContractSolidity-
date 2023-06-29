// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract C2 {

    function demo(string calldata _str) external view returns(bytes32 s) { //если мы напрямую читаем из calldata он не занимает никакую память соотвественно не потребляет газ
        //string memory strCopy = _str; //как можно изменить значение calldata, банально его скопировать
        assembly {
            let freeMemoryPointer := mload(0x40)
            calldatacopy(freeMemoryPointer, 4, calldatasize()) // копия calldata узнаём размер начиная с 4 байта так первые 4 байта это селектор функции
            s := mload(add(freeMemoryPointer, 0x40))
        }
    }
}