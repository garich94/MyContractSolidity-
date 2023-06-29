// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract EnsDomen {
    uint public constant YEAR_SEC = 31536000; 
    address public owner;
    uint public prices = 1 ether;
    uint public ratio = 80;

    struct InfomationTransaction {
        address addr;
        uint timestamp;
        uint price;
        uint age; 
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Only the owner of the contract can do this!");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    mapping(string => InfomationTransaction) public ensDomenRegister;
    
    function addEnsDomen(string memory _ensDomen, uint _age) public payable {
        require(_age >= 1 && _age <= 10, "The domain term is from 1 to 10 years!");
        require(msg.value >= prices * _age, "There are not enough funds to buy a domain!");
        require(ensDomenRegister[_ensDomen].age == 0, "This domain is occupied, choose another one!");
        ensDomenRegister[_ensDomen] = InfomationTransaction(msg.sender, block.timestamp, msg.value, _age);
    }

    function extensionDomen(string memory _ensDomen, uint _ageExtension) public payable {
        require(ensDomenRegister[_ensDomen].addr == msg.sender, "This domain does not belong to your address, enter your domain!");
        require(ensDomenRegister[_ensDomen].timestamp + ensDomenRegister[_ensDomen].age * YEAR_SEC >= block.timestamp, "You cannot renew your domain because your domain has expired!");
        require(msg.value >= prices * _ageExtension * ratio / 100, "There are not enough funds to renew the domain!");
        ensDomenRegister[_ensDomen] = InfomationTransaction(msg.sender, block.timestamp,  msg.value, _ageExtension);
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function withdrawMoney() public payable {
        address payable receiver = payable(owner);
        receiver.transfer(this.getBalance()); 
    }

    function setPrice(uint _newPrice) public onlyOwner {
        prices = _newPrice;
    }

    function setRatio(uint _newRatio) public onlyOwner {
        ratio = _newRatio;
    }

    receive() external payable {}
}