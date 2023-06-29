// SPDX-License-Identifier: MIT

pragma solidity ^0.4.19;



contract ZombieBattle {
  uint randNonce = 0;
  // Здесь создай attackVictoryProbability 

  function randMod(uint _modulus) public view returns(uint) {
    randNonce++;
    return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
  }
}