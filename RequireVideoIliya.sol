// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Demo {
    address public owner;
    uint public total;

    constructor() {
        owner = msg.sender;
    }

    function getMoney() public payable {
        total += msg.value;
    }

    function withdraw(address payable _to) public {
        //require(owner == _to, "Not an owner!");
        //if(owner != _to) {
          //  revert("Not an owner!");// в данном случае обе записи равнозначны 
        //}

        assert(owner == _to); //Panic ошибка assert используется редко

        address thisContract = address(this);
        _to.transfer(thisContract.balance);
        total = 0;
    }

    function totalEth() public view returns(uint) {
        return total / 10 ** 18;
    }

    receive() external payable {
        getMoney();
    }

    fallback() external payable {
        //..
    }
}