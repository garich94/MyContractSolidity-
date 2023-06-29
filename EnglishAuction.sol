// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract EnglishAuction {
    string public item; //предмет который хотим продать
    address payable public immutable seller; //человек который продаёт 
    uint public endAt; //метка времени когда аукцион заканчивается
    bool public started; //начался аукцион или нет
    bool public ended; //закончился аукцион или нет
    uint public highestBid; //самая высокая ставка на данный момент
    address public highestBidder; //тот кто сделал самую большую ставку
    mapping(address => uint) public bids; // адреса и соотвествующие им ставки 

    event Start(string _item, uint _currentPrice); //событие, которое говорит о начале аукциона
    event Bid(address _bidder, uint _bid);
    event End(address _highestBidder, uint _highestBid);
    event Withdraw(address _sender, uint _amount);

    constructor(string memory _item, uint _startingBid) {
        item = _item;//объявляем что за товар выставлен на аукцион
        highestBid = _startingBid;//задаём начальную стоимость
        seller = payable(msg.sender);//информация о том кто это продаёт
    }

    modifier onlySeller { //то чтобы только хозяин этого аукциона мог делать какие-то привелегированные действия
        require(msg.sender == seller, "not a seller");
        _;
    }

    modifier hasStarted { //проверка, что аукцион начался
        require(started, "has not started yet");
        _;
    }

    modifier notEnded { //проверка, что аукцион ещё не закончился
        require(block.timestamp < endAt, "has ended");
        _;
    }

    function start() external onlySeller { //функция которая запускает аукцион
        require(!started, "has alrad");//проверка, что аукцион уже не запущен

        started = true; // даем сигнал того, что наш аукицон начался 
        endAt = block.timestamp + 70; //через сколько наш аукцион завершится
        emit Start(item, highestBid); //данное событие говорит, что продаётся и какая текущая ставка на данный момент
    }

    function bid() external payable hasStarted notEnded { //функция для того, чтобы могли поставить ставку
        require(msg.value > highestBid, "too low"); //проверка что новая ставка больше предыдущей

        if(highestBidder != address(0)) {
            bids[highestBidder] += highestBid;
        }

        highestBid = msg.value; //новая ставка
        highestBidder = msg.sender; //новый человек ставка которого выигрывает на данный момент
        emit Bid(msg.sender, msg.value); //событие, которое говорит о том кто и какую ставку сделал
    }

    function end() external hasStarted { //функция, которая останавливает аукцион
        require(!ended, "already ended");
        require(block.timestamp >= endAt, "can't stop auction yet"); //проверка что пришло время остановить ауцкион

        ended = true;
        if(highestBidder != address(0)) { //это нужно для того, если вдруг аукционом не заинтресовался вообще никто
            seller.transfer(highestBid); //отправить средства самой высокой ставки продавцу
        }
        emit End(highestBidder, highestBid);
    }

    function withdraw() external { //чтобы люди, которые проиграли в аукционе могли вернуть свои средства
        uint refundAmount = bids[msg.sender]; //проверяем сколько поставил данный адрес в аукционе
        require(refundAmount > 0, "incorrect refund amount");//проверка что вообще ли ставил, что адрес

        bids[msg.sender] = 0;
        payable(msg.sender).transfer(refundAmount);
        emit Withdraw(msg.sender, refundAmount);
    }
}