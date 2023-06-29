// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Grenny {

    //счётчик количества внуков 
    uint8 public counter;

    //внесённый бабушкой депозит (в моменте может отличаться от баланса контратка)
    uint public bank;

    //адрес бабушки - владельца контракта 
    address public owner;

    //структура - объект внук 
    struct Grandchild {
        string name;
        uint birthday; //https://www.unixtimestamp.com/
        bool alreadyGotMoney;
        bool exist;
    }

    //массив адресов внуков, для того чтобы иметь возможность 
    //получить полный списко внуков
    address[] public arrGrandchilds;
    //мэппинг, который связывает адрес внука со структурой данных о нём
    mapping(address => Grandchild) public grandchilds;

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner!");
        _;
    }

     constructor() {
        owner = msg.sender;
        counter = 0;
    }

    //Функция добавления внука в контракт 
    function addGrandChild(address walletAddress, string memory name, uint birthday) public onlyOwner {
        require(birthday > 0, "Something is wrong with the date of birth!");
        require(grandchilds[walletAddress].exist == false, "There is already such a grandchild!");
        grandchilds[walletAddress] = Grandchild(name, birthday, false, true);
        arrGrandchilds.push(walletAddress);
        counter++;
        emit NewGrandChild(walletAddress, name, birthday); 
    }

    //функция которая позволяет проверять баланс данного смарт-контракта
    function balanceOf()public view returns(uint) {
        return address(this).balance;
    }

    //функция которая позволяет данному контракту получать ETH
    receive() external payable {
        bank += msg.value;
    }

    //события 
    event NewGrandChild(address indexed walletAddress, string name, uint birthday);
    event GotMoney(address indexed walletAddress);

    //затребовать деньги 
    //хорошая практика использовать паттерн withdraw (требование) вместо паттерна send(отправка)

    function withdraw() public {
        address payable walletAddress = payable(msg.sender);

        require(
            grandchilds[walletAddress].exist == true, 
            "There is no such grandchild!"
        );
        require(
            block.timestamp > grandchilds[walletAddress].birthday,
            "Birthday hasn't arrived yet!"
        );
        require(
            grandchilds[walletAddress].alreadyGotMoney == false,
            "You have already received money!"
        );

        uint amount = bank / counter;
        grandchilds[walletAddress].alreadyGotMoney = true;

        (bool succes, ) = walletAddress.call{value: amount}("");
        require(succes);
        emit GotMoney(walletAddress); 
    }

    //В данном случае мы могли бы сразу возвращать весь массив адресов внуков, потому что их не много
    //но когда мы не знаем, до каких размеров может разрастись массив.
    //хорошая практика запрашивать и отдавать его частями: N-количество элементов,
    //начиная с определённого элемента

    function readGrandChildsArray(uint cursor, uint length) public view returns(address[] memory) {
        address[] memory array = new address[](length);
        uint counter2 = 0;
        for (uint i = cursor; i < cursor + length; i++) {
            array[counter2] = arrGrandchilds[i];
            counter2++;
        }
        return array;
    }
}