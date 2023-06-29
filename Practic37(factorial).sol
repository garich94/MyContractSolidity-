//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
contract MyContract {    
	function factorial(uint number) public pure returns (uint result) {
        result = 1;
        for(uint i = 1; i <= number; i++) {
            result = i * result;
        }
        return result;
    }
} 