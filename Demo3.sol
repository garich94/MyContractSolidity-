// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract ReadAddress {
    function readAddr(address _addr, bytes memory _nonce) public pure returns(address) {
        return address(bytes20(keccak256(abi.encodePacked(_addr, _nonce))));
    }
}