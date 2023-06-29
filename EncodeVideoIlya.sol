// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Demo {
    // Sasha, Petya(encode) ==> 0xac5e9a3012f3185713ada2995649ba5cb0ce6c3fb666a326c8baa40f34dec372
    // Sash, aPetya(encode) ==> 0x6843a92fc88ed8411c6aee645a7151ab58c412b7ff0b3e8b8148db9c8ff264d3
    // Sasha, Petya(encodePacked) ==> 0xe37f5219d60107244e792bd5b1b25154f62d5c0b9f44d1cf7aac4d9f4bc73721
    // Sash, aPetya(encodePacked) ==> 0xe37f5219d60107244e792bd5b1b25154f62d5c0b9f44d1cf7aac4d9f4bc73721
    function doHash(string memory str1, string memory str2) public pure returns (bytes32) {
        return keccak256(doEncode(str1, str2));
    }

    function doEncode(string memory str1, string memory str2) public pure returns(bytes memory) {
        //bytes memory res1 = abi.encode(str1, str2);
        bytes memory res2 = abi.encodePacked(str1, str2);
        return res2;
    }
}