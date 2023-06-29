// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

contract Demo {
    function doEncode(string memory str1, uint int1) public pure returns(bytes memory) {
        bytes memory res1 = abi.encodePacked(str1, int1);
        return res1;
    }

    function doHash(string memory str1, uint int1) public pure returns(bytes32) {
        return keccak256(doEncode(str1, int1));
    }
}