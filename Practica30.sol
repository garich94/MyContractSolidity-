//SPDX-License-Identifier: GPL-3.0 
pragma solidity ^0.8.0;

contract MyContract {
  
 
  struct Friends {
      string name;
      bool invited;
  }
  Friends[] public friendInfomation;
  Friends[] public gostiInfomation;

  function demo(string memory _name, bool _invited) public {
     friendInfomation.push(Friends({name: _name, invited: _invited}));
  }
}