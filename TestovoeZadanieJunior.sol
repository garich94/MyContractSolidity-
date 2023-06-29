// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract VotingContract {
    address public owner; // владелец контракта
    uint public counter; // счётчик голосований
    uint public maxCandidateNum; // максимальное кол-во кандидатов

    struct Candidate {
        uint balance;
        bool isExistOnThisVoting;
    }

    struct Voting {
        bool started;
        address Winner;
        uint StartDate;
        uint WinnerBalance;
        uint Bank;
        uint Period;
        mapping(address => Candidate) Candidates;
    }

    mapping(uint => Voting) private Votings;

    uint public immutable Comission;

    event candidateInfo(
        uint indexed votingID,
        address indexed candidate,
        bool existOnThisVoting
    );

    event votingDraftCreated(uint indexed votingID);
    event votingStarted(uint indexed votingID, uint staerDate);

    modifier onlyOwner() {
        require(msg.sender == owner, "Error! You're not the smart-contract owner!");
        _;
    }

    constructor(uint _maxCandidatesNum, uint _comission) {
        owner = msg.sender;
        Comission = _comission;
        maxCandidateNum = _maxCandidatesNum;
    }

    function takePartInVoting(uint _votingId, address _candidate) public payable {
        require(Votings[_votingId].started, "Voting not started yet");

        require(Votings[_votingId].StartDate + Votings[_votingId].Period > block.timestamp, "Voting is ended");

        Votings[_votingId].Candidates[_candidate].balance += msg.value;
        Votings[_votingId].Bank += msg.value;

        if(
            Votings[_votingId].Candidates[_candidate].balance >
            Votings[_votingId].WinnerBalance
        ) {
            Votings[_votingId].WinnerBalance = Votings[_votingId].Candidates[_candidate].balance;
            Votings[_votingId].Winner = _candidate;
        }
    }

    function WithdrawMyPrize(uint _votingId) public {
        require(Votings[_votingId].started, "Voting not started yet!");
        require(
            Votings[_votingId].StartDate + Votings[_votingId].Period <
                block.timestamp,
            "Voting is not over yet!"
        );
        require(
            msg.sender == Votings[_votingId].Winner,
            "You are not a winner!"
        );
        require(
            Votings[_votingId].Bank > 0,
            "You have already received your prize!"
        );

        uint amount = Votings[_votingId].Bank;
        uint ownerComission = (Comission * amount) / 100;
        uint clearAmount = amount - ownerComission;
        Votings[_votingId].Bank = 0;
        payable(owner).transfer(ownerComission);
        payable(msg.sender).transfer(clearAmount);
    }

    function getVotingInfo(uint _votingId) public view returns(bool, uint, uint, uint, uint, address) {
        return(
            Votings[_votingId].started,
            Votings[_votingId].StartDate,
            Votings[_votingId].Period,
            Votings[_votingId].WinnerBalance,
            Votings[_votingId].Bank,
            Votings[_votingId].Winner
        );
    }

    function checkCandidate(uint _votingId, address _candidate) public view returns(bool) {
        return (
            Votings[_votingId].Candidates[_candidate].isExistOnThisVoting 
        );
    }

    function addVoting(uint _period,address[] calldata _candidates) public onlyOwner {
        require(_candidates.length < maxCandidateNum, "Too many candidates!");
        Votings[counter].Period = _period;
        for(uint i = 0; i < _candidates.length; i++) {
            addCandidate(counter, _candidates[i]);
        }
        emit votingDraftCreated(counter);
        counter++;
    }

    function startVoiting(uint _votingId) public onlyOwner {
        Votings[_votingId].started = true;
        Votings[_votingId].StartDate = block.timestamp;
        emit votingStarted(_votingId, block.timestamp);
    }

    function editVotingPeriod(uint _votingId, uint _newPeriod) public onlyOwner {
        require(Votings[_votingId].started == false, "Voting has already begun!");

        Votings[_votingId].Period = _newPeriod;
    }

    function addCandidate(uint _votingId, address _candidate) public onlyOwner {
        require(Votings[_votingId].started == false, "Voting has already begun!");

        Votings[_votingId].Candidates[_candidate].isExistOnThisVoting = true;
        emit candidateInfo(_votingId, _candidate, true);
    }

    function deleteCandidate(uint _votingId, address _candidate) public onlyOwner {
        require(
            Votings[_votingId].started == false, "Voting has already begun!"
        );

        Votings[_votingId].Candidates[_candidate].isExistOnThisVoting = false;
        emit candidateInfo(_votingId, _candidate, false);
    }

    function setMaxCandidatesNum(uint _maxCandidatesNum) public onlyOwner {
        maxCandidateNum = _maxCandidatesNum;
    }
}