// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract MultiDelegateCall {
    uint[] public results;

    function multiCall(bytes[] calldata data) external {
        for(uint i; i < data.length; i++) {
            (bool success, bytes memory result) = address(this).delegatecall(data[i]);
            require(success, "tx failed!");
            results.push(abi.decode(result, (uint)));
        }
    }
}

contract Calculations is MultiDelegateCall {
    event Log(address caller, string calcName, uint result);

    function calc1(uint x, uint y) external returns(uint) {
        uint result = x + y;
        emit Log(msg.sender, "calc1", result);
        return result;
    }

    function calc2(uint x, uint y) external returns(uint) {
        uint result = x * y;
        emit Log(msg.sender, "calc2", result);
        return result;
    }

    function encodeCalc1(uint x, uint y) external pure returns(bytes memory) {
        return abi.encodeWithSelector(Calculations.calc1.selector, x, y);
    }

    function encodeCalc2(uint x, uint y) external pure returns(bytes memory) {
        return abi.encodeWithSelector(Calculations.calc2.selector, x, y);
    }
}