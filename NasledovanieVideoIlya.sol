// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./OwnedVideoIlya.sol";

contract Demo is Owned {
    function withdraw(address payable _to) public onlyOwner {
        address thisContract = address(this);
        _to.transfer(thisContract.balance);
    }

     function parentFunc() public override pure returns(uint) {
        return 100;
    }
}