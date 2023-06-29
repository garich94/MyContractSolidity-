// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Demo {
    address public owner;
    event Deployed(address _thisAddr, uint _balance);

    constructor(address _owner) payable {
        owner = _owner;
        emit Deployed(address(this), getBalance());
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
}

contract Create2 {
    event Deploy(address _newContract);
    
    function deploy(uint _salt) external payable {
        Demo newContract = new Demo{
            salt: bytes32(_salt),
            value: msg.value
        }(msg.sender);
        emit Deploy(address(newContract));
    }

    function getBytecode(address _owner) public pure returns(bytes memory) {
        bytes memory bytecode = type(Demo).creationCode;
        return abi.encodePacked(bytecode, abi.encode(_owner));
    }

    function getAddress(bytes memory bytecode, uint _salt) public view returns(address) {
        bytes32 hash = keccak256(
            abi.encodePacked(
                bytes1(0xff), address(this), _salt, keccak256(bytecode)
            )
        );

        return address(uint160(uint(hash)));
    }
      
}