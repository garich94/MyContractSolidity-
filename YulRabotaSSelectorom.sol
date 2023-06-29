// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract C3 {
    function encSel() external pure returns(bytes memory) {
        return abi.encodeWithSelector(C3.demo.selector, "test"); // низкоуровневый вызов функции demo
        // более привычный способ посчитать селектор функции
        //return bytes4(keccak256(bytes("demo(string)"))); // таким образом преобразовывается наш селектор функции берутся первые 4 байта памяти
        // 0x939a79ac - это селектор нашей функции demo(string)
    }

    function demo(string calldata _str) external view returns(bytes memory) {

        assembly {

        }

        return msg.data;
    }

    function demoArrayCalldata(uint8[] calldata err) external view returns(bytes4 _sel, bytes32 _startIn) {
        assembly {
            _sel := calldataload(0)
            _startIn := calldataload(4)
        }
    

        //return msg.data;
    }
}