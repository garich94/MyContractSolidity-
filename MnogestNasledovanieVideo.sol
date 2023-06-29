// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./MnogestOwnedTopParent.sol";

contract Demo is TopParent, Owned {
    function withdraw(address payable _to) public onlyOwner {
        address thisContract = address(this);
        _to.transfer(thisContract.balance);
    }

      function parentFunc() public override(TopParent, Owned) pure returns(uint) {
        return 100;
    }
}