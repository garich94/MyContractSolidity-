// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./StringsOZ.sol";
import "./IERC721Receiver.sol";

contract Demo {
  mapping(uint => address) private _owners;
  using Strings for uint;


  function ownerOf(uint tokenId) public view returns(address) {
        return _owners[tokenId];
    }

    using Strings for uint;

  function _baseURI() internal pure returns(string memory) {
    return "https://";
  }

  function tokenURI(uint tokenId) external view returns(string memory) {
    string memory baseURI = _baseURI();

    string memory baseURI_TokenId = string(abi.encodePacked(baseURI, tokenId.toString()));

    if(bytes(baseURI).length > 0) {
      return baseURI_TokenId;
    }
    
    return "";
  }

  function checkCodeLength(address to) public view returns(bool) {
    return to.code.length > 0;
  }
}

contract Demo2 {

  address public owner;

  constructor() {
    owner = msg.sender;
  }
}
  
  
  
  
  
  
  
  
  
  
  
  
  
