// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

interface IRecordAddable {
    function addRecord(Record record) external;
}

contract RecordFactory {
    IRecordAddable recordAddable;

    constructor(IRecordAddable _recordAddable) {
        recordAddable = _recordAddable;
    }

    function onRecordAdding(Record record) internal {
        recordAddable.addRecord(record);
    }
}

abstract contract Record {
    uint public immutable timeOfCreation = block.timestamp;
    function getRecordType() public pure virtual returns(string memory);
}

contract RecordsStorage is Ownable {
    Record[] public records;

    mapping(address => bool)public factories;

    function addRecord(Record record) external {
        require(factories[msg.sender] == true, "Your factory is not added to the allowed list!");
        records.push(record);
    }

    function addFactory(address _addr) public onlyOwner {
        factories[_addr] = true;
    }
}

contract StringRecord is Record {
    string public record;

    constructor(string memory _record) {
        record = _record;
        timeOfCreation;
    }

    function getRecordType() public pure override returns(string memory) {
         return "string"; 
    }

    function setRecordStrings(string memory _record) public {
        record = _record;
    }
}

contract AddressRecord is Record {
    address public record;

    constructor(address _record) {
        record = _record;
        timeOfCreation;
    }

     function getRecordType() public pure override returns(string memory) {
         return "address"; 
    }

    function setRecordAddr(address _record) public {
        record = _record;
    }
}

contract EnsRecord is Record {
    address public owner;
    string public domain;
    
    constructor(string memory _domain, address _owner) {
        domain = _domain;
        owner = _owner;
        timeOfCreation;
    }

    function getRecordType() public pure override returns(string memory) {
        return "ens";
    }

    function setOwner(address _owner) public {
        require(owner == msg.sender, "only the owner can add a new domain owner!");
        owner = _owner;
    }
}

contract StringRecordFactory is RecordFactory {
    constructor(IRecordAddable _recordAddable) RecordFactory(_recordAddable) {}

    function addRecordString(string memory _record) public {
        StringRecord newStringRecord = new StringRecord(_record);
        onRecordAdding(newStringRecord);
    }
}

contract AddressRecordFactory is RecordFactory {
    constructor(IRecordAddable _recordAddable) RecordFactory(_recordAddable) {}

    function addRecordAddress(address _record) public {
        AddressRecord newAddressRecord = new AddressRecord(_record);
        onRecordAdding(newAddressRecord);
    }
}

contract EnsRecordFactory is RecordFactory {
    constructor(IRecordAddable _recordAddable) RecordFactory(_recordAddable) {} 
   
    function addRecordEns(string memory _domain, address _owner) public {
        EnsRecord newEnsRecord = new EnsRecord(_domain, _owner);
        onRecordAdding(newEnsRecord);
    }
}