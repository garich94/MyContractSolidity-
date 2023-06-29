// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract MyContract {
    uint[] public items = [1, 2, 3];

    function demo(uint _index) public view returns(uint) {
        return items[_index];
    }
}