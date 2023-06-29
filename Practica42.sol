// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract NoMore {
    address public owner;
    address[] public arrCash;
    bool alive = true;

    constructor() {
        owner = msg.sender;
    }

    function checkeng(address[] memory _arr) public {
         require(alive, "I'm dead!");
        
        for(uint8 i; i < _arr.length; i++) {
            if(_arr[i].balance > 3 ether) {
                arrCash.push(_arr[i]);
            }
        }
    }

    function destroy() public {
        require(alive, "I'm dead!");

        if(arrCash.length > 30) {
            address payable _to = payable(owner);
            _to.transfer(owner.balance);
            alive = false;
        }    
    }

}