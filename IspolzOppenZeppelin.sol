// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol";

contract LibDemo {
    using Strings for uint;

    function testConverter(uint num) public pure returns(string memory) {
        return num.toString();
    }
}