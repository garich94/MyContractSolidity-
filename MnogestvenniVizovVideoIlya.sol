// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Person {
    string name;
    string surname;

    function setName(string memory _name) public {
        name = _name;
    }

    function setSurname(string memory _surname) public {
        surname = _surname;
    }

    function getName() external view returns(string memory) {
        return name;
    }

    function getSurname() external view returns(string memory) {
        return surname;
    }

    function encGetName() external pure returns(bytes memory) {
        return abi.encodeWithSelector(this.getName.selector);
    }

    function encGetSurname() external pure returns(bytes memory) {
        return abi.encodeWithSelector(this.getSurname.selector);
    }
}

contract Caller {
    function multiCall(address[] calldata targets, bytes[] calldata data) public view returns(string[] memory) {
        require(targets.length == data.length, "invalid targets/data");
        string[] memory results = new string[](targets.length);

        for(uint i; i < targets.length; i++) {
            (bool success, bytes memory result) = targets[i].staticcall(data[i]);
            require(success, "call failed!");
            results[i] = abi.decode(result, (string));
        }

        return results;
    }

    function multiCallTx(address[] calldata targets, bytes[] calldata data) public {
        require(targets.length == data.length, "invalid targets/data");

        for(uint i; i < targets.length; i++) {
            (bool success,) = targets[i].call(data[i]);
            require(success, "tx failed!");
        }
    }

    function encode(string calldata _func, string calldata _arg) public pure returns(bytes memory) {
        return abi.encodeWithSignature(_func, _arg);
    }
}

