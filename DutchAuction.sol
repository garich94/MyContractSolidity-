// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract DutchAuction {
    uint private constant DURATION = 2 days; //продолжительность аукциона
    address payable public immutable seller; //тот кто продаёт
    uint public immutable startingPrice; //начальная цена, примечательно, что она максимальная 
    uint public immutable startAt; //время начала аукциона
    uint public immutable endsAt; //время окончания аукциона
    uint public immutable discountRate; //дисконта на сколько будет уменьшаться наша цена, по истечению какого-то времени
    string public item; //название товара
    bool public stopped; //остановлен ли наш аукцион

    constructor(uint _startingPrice, uint _discountRate, string memory _item) {
        seller = payable(msg.sender); //задаём владельца контракта
        startingPrice = _startingPrice;
        discountRate = _discountRate;
        startAt = block.timestamp;
        endsAt = block.timestamp + DURATION;
        require(_startingPrice >= _discountRate * DURATION, "starting price and discount is incorrect"); //проверка, делается для того чтобы цена не ушла в отрицательное значение

        item = _item; //сохраняем информацию о предмете
    }

    modifier notStopped() { //проверка завершился ли наш аукцион
        require(!stopped, "stopped");
        _;
    }

    function getPrice() public view notStopped returns(uint) { // функция показывает текущую стоимость предмета
        uint timeElapsed = block.timestamp - startAt; // сколько времени уже прошло с момента начала аукциона
        uint discount = discountRate * timeElapsed; // чем больше времени прошло, тем ниже опускается цена
        return startingPrice - discount;
    }

    function buy() external payable notStopped { //функция покупки данного предмета
        require(block.timestamp < endsAt, "ended"); //проверка не закончилось ли время аукциона
        uint price = getPrice(); //узнаём цену на данный момент
        require(msg.value >= price, "not enough funds"); //проверка, что кол-во средств, которые перевели достаточно для покупки

        uint refund = msg.value - price; //если вдруг нам прислали больше, чем нужно создаём возврат средств
        if(refund > 0) {
            payable(msg.sender).transfer(refund); //отправляем излишни, которые нам прислали
        }
        seller.transfer(address(this).balance); //забираем средства сразу себе на адрес
        stopped = true; //остнавливаем аукцион
    }
}