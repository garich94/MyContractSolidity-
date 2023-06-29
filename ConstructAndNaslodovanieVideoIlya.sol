// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./OwnedAndTopParent.sol";

//contract Demo is TopParent("Sashka"), Owned(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4)

contract Demo is TopParent, Owned {
    constructor(string memory _name, address _addr) TopParent(_name) Owned(_addr) {}
    function withdraw(address payable _to) public onlyOwner {

    }
}