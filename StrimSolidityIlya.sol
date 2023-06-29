// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract EngAuction {   
  string public item;
  address public immutable seller;
  uint public constant DURATION = 1 days;
  bool started; // false
  bool ended; // false
  uint public endsAt;
  address public currentWinner;
  uint public currentMaxBet;
  mapping(address => uint) public bets;
  address[] public betters;
  address[] public failedPaids;

  event BetPlaced(address indexed better, uint indexed amount);
  event Started(uint currentPrice, uint endsAt);

  constructor(string memory _item, uint startingPrice) {
    item = _item;
    seller = msg.sender;
    currentMaxBet = startingPrice; // ?
  }

  modifier onlySeller() {
    require(msg.sender == seller);
    _;
  }

  function start() external onlySeller {
    require(!started, "already started");
    started = true;
    endsAt = block.timestamp + DURATION;

    emit Started(currentMaxBet, endsAt);
  }

  function bet() external payable {
    require(started && !ended, "wrong state!");
    require(msg.value > currentMaxBet, "too low!");

    if(bets[msg.sender] == 0) {
      betters.push(msg.sender);
    }
    
    bets[currentWinner] += currentMaxBet;

    currentWinner = msg.sender;
    currentMaxBet = msg.value;

    emit BetPlaced(msg.sender, msg.value);
  }

  function end() external {
    require(!ended, "already ended");
    require(block.timestamp > endsAt, "too early!");

    ended = true;
    
    if(currentWinner != address(0)) {
      payable(seller).transfer(currentMaxBet);
    }
  }
} 