// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract MyContract {
    address public sender;
    uint public amount;

    address otherContract;

    constructor(address _otherContract) {
        otherContract = _otherContract;
    }

    function delCallGetData() external payable {
        (bool success, ) = otherContract.delegatecall(
            abi.encodeWithSelector(AnotherContract.getData.selector)
        );
        require(success, "failed!");
    }

}

contract AnotherContract {
    address public sender;
    uint public amount;

    event Received(address sender, uint value);

    function getData() external payable {
        sender = msg.sender;
        amount = msg.value;
        emit Received(msg.sender, msg.value);
    }
}