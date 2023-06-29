//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract CustomErrorDemo {
    address public owner;
    error NotPermited(address _to, uint _amount);

    constructor() {
        owner = msg.sender;
    }

    function withdraw(uint _amount) public {
        //24042 gas, 24060, 23788, 24094
        if(msg.sender != owner) {
            revert NotPermited(msg.sender, _amount);
            //revert("Error was has privet! Poka kak dela what gasd sfddsf lkklfdsklf!");
        }

        payable(msg.sender).transfer(_amount);
    }
}