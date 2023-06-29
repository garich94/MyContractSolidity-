// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

abstract contract Record {
    uint public immutable timeOfCreation = block.timestamp;
    function getRecordType() public pure virtual returns(string memory);
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

contract RecordFactory {
    Record[] public records;

    function addRecord(string memory _record) public {
        StringRecord newStringRecord = new StringRecord(_record);
        records.push(newStringRecord);
    }

    function addRecord(address _record) public {
        AddressRecord newAddressRecord = new AddressRecord(_record);
        records.push(newAddressRecord);
    }
}


