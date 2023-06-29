// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "./ERC20.sol";

contract Crowd {
    struct Campaing { //структура данных, которая описывает одну компанию(мб много компаний) 
        address owner; //владелец данной компании
        uint goal; //сколько конкретно нужно собрать денежных средств
        uint pledged; //сколько пожертвовано на данный момент
        uint startAt; //время начала этой компании
        uint endAt; //время окончания этой компании
        bool claimed; //забрали ли организаторы компании денежные средства(средства можно забрать если компания уже закончена и достигнута цель)
    }

    ERC20 public immutable token; //ссылка на тот токен, который хотим здесь задействовать
    mapping(uint => Campaing) public campaings; //ключём будет идентификатор компании в качестве значения будет выступать сама компания 
    uint public currentId; //чтобы бы отслеживать самый свежий идентификатор

    mapping(uint => mapping(address => uint)) public pledges; // сколько на конкретную компанию пожертваовали, конкретный люди
    uint public constant MAX_DURATION = 100 days; //максимальная продолжительность сбора средств
    uint public constant MIN_DURATION = 10; //минимальная время компании

    event Launched(uint id, address owner, uint goal, uint startAt, uint endAt);
    event Cancel(uint id);
    event Pledged(uint id, address pledged, uint amount);
    event Unpledged(uint id, address pledged, uint amount);
    event Claimed(uint id);
    event Refunded(uint id, address pledger, uint amount);

    constructor(address _token) { //задаём адрес токена с которым мы хотим работать
        token = ERC20(_token);
    }

    function launch(uint _goal, uint _startAt, uint _endAt) external { //функция запуска
        // require(_startAt >= block.timestamp, "incorrect start at"); //время начала больше либо равно текущему
        // require(_endAt >= _startAt + MIN_DURATION, "incorrect end at"); //проверка, что время конца больше чем время начала
        // require(_endAt <= _startAt + MIN_DURATION, "too long"); //проверка на максимальную длительность

        campaings[currentId] = Campaing({ //добавляем новую компанию
            owner: msg.sender, 
            goal: _goal,
            pledged: 0,
            startAt: block.timestamp,
            endAt: block.timestamp + 40,
            claimed: false
        });

        emit Launched(currentId, msg.sender, _goal, _startAt, _endAt);

        currentId += 1; //чтобы у новой компании был новый идентификатор
    } 

    function cancel(uint _id) external { //отмена компании по сбору средств
        Campaing memory campaing = campaings[_id]; //получаем новую компанию из памяти для того чтобы проверить, кто является владельцем данной компании
        require(msg.sender == campaing.owner, "not an owner"); //проверка для того чтобы только владелец компании мог остановить сбор средств
        require(block.timestamp < campaing.startAt, "already started!"); //если компания уже началась её остановить нельзя уже

        delete campaings[_id];
        emit Cancel(_id);
    }

    function pledge(uint _id, uint _amount) external { //основная функция, которую будут вызывать клиенты, чтобы сделать пожертвования для той или иной компании
        Campaing storage campaing = campaings[_id]; //так как здесь будем менять компанию поэтому обращаемся к storage, если нам нужно было бы прочитать компанию обращаемся к memory
        require(block.timestamp >= campaing.startAt, "not started!"); //проверяем, что компания по сбору средств уже началась
        require(block.timestamp <= campaing.endAt, "ended"); //проверяем, что компания по сбору средств ещё не закончилась

        campaing.pledged += _amount; //прибавляем средства, которые нам пожертвовали
        pledges[_id][msg.sender] += _amount; //добавляем с мэппинг, что такой то пользователь, пожертвовал нам средств
        token.transferFrom(msg.sender, address(this), _amount); //списываем пожертвование со счёта нашего пользователя 
         
        emit Pledged(_id, msg.sender, _amount);
    }

    function unpledge(uint _id, uint _amount) external { //функция, чтобы забрать своё пожертование
        Campaing storage campaing = campaings[_id]; //так как здесь будем менять компанию поэтому обращаемся к storage, если нам нужно было бы прочитать компанию обращаемся к memory
        require(block.timestamp < campaing.endAt, "ended"); //проверка что компания по сбору средств ещё не заврешилась

        campaing.pledged -= _amount;
        pledges[_id][msg.sender] -= _amount;
        token.transfer(msg.sender, _amount);
        emit Unpledged(_id, msg.sender, _amount);
    }

    function claim(uint _id) external { //функция для того, чтобы компания могла забрать пожертвованные ей средства
        Campaing storage campaing = campaings[_id]; //так как здесь будем менять компанию поэтому обращаемся к storage, если нам нужно было бы прочитать компанию обращаемся к memory
        require(msg.sender == campaing.owner, "not an owner"); //проверка, что msg.sender является владельцем данной компании
        require(block.timestamp > campaing.endAt, "not ended"); //проверка, что компания уже закончилась
        require(campaing.pledged >= campaing.goal, "pledged is too low"); //проверка что собрали, столько или больше чем нужно было
        require(!campaing.claimed, "already claimed"); //проверка, что деньги не были ещё забраны

        campaing.claimed = true; //сразу меняем на то что деньги забрали
        token.transfer(msg.sender, campaing.pledged); //выводим все средства на адрес инициатора транзакции
        emit Claimed(_id);
    }

    function refund(uint _id) external { //функция, чтобы деньги забрать, тому кто пожертвовал, если цель достигнута не была
        Campaing storage campaing = campaings[_id]; //так как здесь будем менять компанию поэтому обращаемся к storage, если нам нужно было бы прочитать компанию обращаемся к memory
        require(block.timestamp > campaing.endAt, "not ended"); //проверка что компания завершилась
        require(campaing.pledged < campaing.goal, "reached goal"); //проверка что пожертвовали меньше, чем требовалось

        uint pledgedAmount = pledges[_id][msg.sender]; //узнаём сколько всего пожертвовали мы
        pledges[_id][msg.sender] = 0; //зануляем наши пожертвования
        token.transfer(msg.sender, pledgedAmount); //выводим токены к себе обратно
        emit Refunded(_id, msg.sender, pledgedAmount);
    }
}