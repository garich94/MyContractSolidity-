// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract LibDemo {
    using SafeMath for uint;

    uint public a;

    constructor() {
        a = 42;
    }

    function testAddition(uint b) public {
        a = a.add(b);
    }
}