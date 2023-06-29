// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract Voting {
  address public owner;
  // выдвижение ---> голосование ---> подсчёт
  uint public constant DURATION =  60 seconds;                 //1 days;
  uint public constant ENROLLMENT_DURATION = 60 seconds;       //1 days;
  uint public constant VOTE_PRICE = 1 ether;
  uint public startsAt;
  uint public stopsAt;
  uint public time = block.timestamp;
  
  struct Candidate {
    string name;
    string surname;
    uint votes;
    bool registered;
  }

  struct Voter {
    address delegate;
    bool voted;
  }

  address[] public winners;
  address[] public voters;
  address[] public candidates;
  mapping(address => Candidate) public candidatesData;
  //mapping(address => uint) public votes;
  mapping(address => Voter) public votersData;
  
  
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }
  
  constructor() {
    owner = msg.sender;
    startsAt = block.timestamp + ENROLLMENT_DURATION;
    stopsAt = startsAt + DURATION;
  }

  function enroll(string calldata _name, string calldata _surname) public {
    require(startsAt > block.timestamp);
    bytes32 emptyStr = keccak256(abi.encode(""));
    
    require(keccak256(abi.encode(_name)) != emptyStr && keccak256(abi.encode(_surname)) != emptyStr);

    //bytes32 hashedName = keccak256(abi.encode(candidatesData[msg.sender].name));
    //bytes32 hashedSurname = keccak256(abi.encode(candidatesData[msg.sender].surname));
    
    //require(hashedName == emptyStr && hashedSurname == emptyStr);
    require(!candidatesData[msg.sender].registered);

    Candidate memory candidate = Candidate(_name, _surname, 0, true);
    candidates.push(msg.sender);
    candidatesData[msg.sender] = candidate;
  }

  function makeVote(address _candidateAddr) external payable {
    require(startsAt <= block.timestamp && stopsAt > block.timestamp);
    Candidate storage candidate = candidatesData[_candidateAddr];
    require(candidate.registered);
    require(msg.value == VOTE_PRICE);

    Voter memory voter = Voter(_candidateAddr, true);
    voters.push(msg.sender);
    votersData[msg.sender] = voter;

    candidate.votes++;
  }

  function stopVoting() public returns(address[] memory) {
    require(stopsAt <= block.timestamp);
    uint currentMax;
    uint currentNumWinners;
    address[] memory localWinners = new address[](candidates.length);
    
    for(uint i = 0; i < candidates.length; i++) {
      address candidateAddr = candidates[i];
      uint _votes = candidatesData[candidateAddr].votes;
      
      if(_votes > currentMax) {
        currentMax = _votes;
        currentNumWinners = 1;
        localWinners[0] = candidateAddr;
      } else if(_votes == currentMax) {
        currentNumWinners++;
        localWinners[currentNumWinners - 1] = candidateAddr;
      }
    }
    for(uint i = 0; i < currentNumWinners; i++) {
      winners.push(localWinners[i]);
    }
  
    return localWinners;
  }
  
}