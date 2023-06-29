// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract TopParent {

}

contract Owned {
    function parentFunc() public virtual pure returns(uint) {
        return 4;
    }
}