// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract MyContract {
    address otherContract;
    event Response(string response);

    constructor(address _otherContract) {
        otherContract = _otherContract;
    }

    function callReceive() external payable {
       (bool success, ) = otherContract.call{value: msg.value}("");
       require(success, "can't send funds!");
    }

    function callSetName(string calldata _name) external {
        (bool success, bytes memory response) = otherContract.call(
            //abi.encodeWithSignature("setName(string)", _name)
            //равно значная запись будет( но только если есть исходник контракта)
            abi.encodeWithSelector(AnotherContract.setName.selector, _name)
        );

        require(success, "can't set name!");

        emit Response(abi.decode(response, (string)));
    }
}

contract AnotherContract {
    string public name;
    mapping(address => uint) public balances;

    function setName(string calldata _name) external  returns(string memory) {
        name = _name;
        return name;
    }

    receive() external payable {
        balances[msg.sender] += msg.value;
    }
}
