// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract ContactFactory {
    mapping(address => address) public ownerToContact;

    modifier onlyNewRecords() {
        require(ownerToContact[msg.sender] == address(0), "You already leave your contract!");
        _;
    }

    function createContact(string memory _telegram, string memory _disc) public onlyNewRecords {
        Contact contact = new Contact(msg.sender, _telegram, _disc);
        ownerToContact[msg.sender] = address(contact);
    }

      function createContact(string memory _telegram) public onlyNewRecords {
        Contact contact = new Contact(msg.sender, _telegram, "");
        ownerToContact[msg.sender] = address(contact);
    }
}

contract Contact {
    address public owner; //адрес владельца
    string public telegram; //ссылка на телеграм
    string public discord; //ссылка на дискорд
    string public desc; //описание 

    constructor(address _owner, string memory _telegram, string memory _discord) {
        owner = _owner;
        telegram = _telegram;
        discord = _discord;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "poshel von!");
        _;
    }

    function setTelegram(string memory _telegram) public onlyOwner{
        telegram = _telegram;
    }

    function setDiscrod(string memory _discord) public onlyOwner{
        discord = _discord;
    }

    function setDesc(string memory _desc) public onlyOwner{
        desc = _desc;
    }
}