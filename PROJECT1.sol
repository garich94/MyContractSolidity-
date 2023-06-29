// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract EnsDomen {

    struct InfomationTransaction {
        address addr;
        uint timeStamp;
        uint price;
    }

    mapping(string => InfomationTransaction) public ensDomenRegister;
    
    function addEnsDomen(string memory _ensDomen) public payable { 
        ensDomenRegister[_ensDomen] = InfomationTransaction(msg.sender, block.timestamp, msg.value);
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function withdrawMoney() public {
        address payable receiver = payable(msg.sender);
        receiver.transfer(getBalance()); 
    }
}