// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Solver {
    address public contractSolver;
    bytes public value;

    function creationContract(bytes memory data) public {
        address addrContract;
        
        assembly {
            addrContract := create(0, add(data, 0x20), mload(data))
        }

        contractSolver = addrContract;
    }

    function sizeContract(address _contract) public view returns(uint256) {
        return _contract.code.length;
    }

    function callContract(address _contract) public {
        (bool success, bytes memory data) = _contract.call("0x0"); // вызываем безымянную фукнцию
        require(success);
        value = data;
    }
}


// push 2a
// push 80

// mstore(offset, value)

// push 20
// push 80

// return(offset, size)

// 60_0a_60_0c_60_00_39_60_20_60_00_f3_60_2a_60_80_52_60_20_60_80_f3
// 60_2a_60_80_52_60_20_60_80_f3

// push 0a
// push __
// push 00
// codecopy(destOffset, offset, size)

// push 20
// push 00

// return (offset, size)

//0x600a600c600039600a6000f3602a60805260206080f3