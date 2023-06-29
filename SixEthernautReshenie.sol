// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Hash {
    function getHash(string memory _func) external pure returns(bytes32) {
        return keccak256(abi.encodePacked(_func));
    }
}
