//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract MyContract {    
    uint[] public number;
    uint public length;

   

    function addMassiv() public {
        for(uint i = 48; i <= 203; i++) {
            if(i % 5 == 0){
                number.push(i);
            }
        } 
        length = number.length;        
    }
} 