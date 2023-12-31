// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin-contracts/contracts/access/Ownable.sol";

contract SharedWallet is Ownable {
    mapping(address => uint) public members;

    modifier ownerOrWithinLimits(uint _amount) {
        require(isOwner() || members[msg.sender] >= _amount, "not allowed!");
        _;
    }

    function isOwner() internal view returns(bool) {
        return owner() == msg.sender;
    }

    function addLimit(address _member, uint _limit) external {
        members[_member] = _limit;   
    }

    function deduceFromLimit(address _member, uint _amount) internal {
        members[_member] -= _amount;
    }

    function renounceOwnership() public view override onlyOwner {
        revert("Can't renounce!");
    }
}   