//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract MyContract {    
  address[] public addrList = [0x6119806E928EbF578e7ABC4F6ae73BFd8a8462cD, 0x0F9c56371ab9f277280e0d2Ec68ea5C901a02CDb, 0xc84772C4d95c4f2E12f829b99eB181ED3106611a, 0x5A0CC2C6bF2cEB1cB9B57541fDAa1Fb794A1a1be, 0xc74cB1F17de290348beA287Ae29F67e7AECd75dD];

  function demo() public {
      for(uint i = 0; i < addrList.length; i++){
          if (i % 2 == 0 && i != 0){
              addrList[i] = msg.sender;
          }
      }
  }
} 