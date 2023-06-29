//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract SharedWalletDop is Ownable {
  event LimitChanged(address indexed _addr, uint _wasLimit, uint _hasLimit);
      
  struct InfomationsMembers {
      string name;
      uint limit;
      bool is_admin;
  }

  mapping(address => InfomationsMembers) public members;
    
  function isOwner() internal view returns(bool) {
    return owner() == _msgSender();
  }
    
  modifier ownerOrWithinLimits(uint _amount) {
    require(isOwner() || members[_msgSender()].limit >= _amount, "You are not allowed to perform this operation!");
    _;
  }
    
  function addLimit(address _member, uint _limit, string memory _name) public onlyOwner {
    members[_member] = InfomationsMembers(_name, _msgSender() != _member ? _limit : 2 ** 255, _msgSender() == _member ? true : false);     
  }

  function deleteLimitAddress(address _deleteAddr) public onlyOwner {
      delete members[_deleteAddr];
  }

  function changeLimit(address _member, uint _amount) public onlyOwner {
      uint _wasLimit = members[_member].limit;
      uint _hasLimit = members[_member].limit -= _amount;

      emit LimitChanged(_member, _wasLimit, _hasLimit);
  }
    
  function deduceFromLimit(address _member, uint _amount) internal {
    members[_member].limit -= _amount;
  }
    
  function renounceOwnership() override public view onlyOwner {
    revert("Can't renounce!");
  }

  

}