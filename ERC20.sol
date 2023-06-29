// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IERC20 {
    function decimals() external pure returns(uint);

    function totalSupply() external view returns(uint);

    function balanceOf(address account) external view returns(uint);

    function transfer(address to, uint amount) external;

    function allowance(address owner, address spender) external view returns(uint);

    function approve(address spender, uint amount) external;

    function transferFrom(address sender, address recipient, uint amount) external;

    event Transfer(address indexed from, address indexed to, uint amount);

    event Approval(address indexed owner, address indexed to, uint amount);
}


// Account #0: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 (10000 ETH)
// Private Key: 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

// Account #1: 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 (10000 ETH)
// Private Key: 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d

contract ERC20 is IERC20 {
    uint totalTokens; //сколько всего токенов существует
    address owner;
    mapping(address => uint) balances; // кол-во токенов для определённого адреса
    mapping(address => mapping(address => uint)) allowances; //на какой адрес можно перевести определённое кол-во токенов
    string public name; //название токена
    string public symbol; //сокращённое название токена

    constructor(string memory _name, string memory _symbol, uint initialSupply) { //через конструктор задаем сразу кол-во токенов
        owner = msg.sender;
        name = _name;
        symbol = _symbol;
        mint(owner ,initialSupply);
    }

    modifier enoughTokens(address _from, uint _amount) { //проверка достаточно ли токенов на каком-то адресе
        require(balanceOf(_from) >= _amount, "Not enough tokens!");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not enough owner!");
        _;
    }
    
    function decimals() external pure returns(uint) { //реализуем функцию сколько нулей может быть после запятой, в данном случае наш токен не может быть дробным
        return 0;
    }

    function totalSupply() public view returns(uint) { //данная функция вернёт сколько всего токенов ERC20 наших существует
        return totalTokens; 
    }

    function balanceOf(address account) public view returns(uint) { //узнаём кол-во токенов на конкретном счету, узнаём это всё через наш мэппинг 
        return balances[account];
    }

    function transfer(address to, uint amount) external enoughTokens(msg.sender, amount) { //функция которая забирает у нас средства и переводит их на определённый адрес и порождает событие Transfer
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }

    function allowance(address _owner, address spender) external view returns(uint) { //функция говорит с какого адреса в пользу какого и какое кол-во можно списать токенов
        return allowances[_owner][spender];
    }

    function approve(address spender, uint amount) external { //функция которая позволит подтвердить, что я хочу в чью-то пользу списать какие-то деньги 
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
    }

    function transferFrom(address sender, address recipient, uint amount) public enoughTokens(sender, amount) { //функция чтобы мог кто-то другой с моего счёта списывать какое-то кол-во токенов, если я это позволил 
        allowances[sender][recipient] -= amount;
        balances[sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }

    function mint(address to, uint amount) public onlyOwner() { //чеканка, доп эмиссия в оборот токенов
        balances[to] += amount;
        totalTokens += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint amount) external enoughTokens(msg.sender, amount) { //функция позволяющая выводить токены из оборота(сжигать эмиссию)
        balances[msg.sender] -= amount;
        totalTokens -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

    //задействуем enoughTokens 

    fallback() external payable{}

    receive() external payable{}
}

contract MCSToken is ERC20 {
    constructor() ERC20("SashkaToken", "STK", 1000) {}
}

//продажа токенов через смарт-контракт

contract TokenSell {
    IERC20 public token;//переменная реализует интерфейс(ссылка на наш контракт)
    address owner; //владелец 
    address public thisAddr = address(this); //адрес текущего магазина

    event Bought(address indexed buyer, uint amount); //какой адрес купил и в каком количестве
    event Sell(address indexed seller, uint amount); //если кто-то захотел продать, кто и в каком количестве

    constructor(IERC20 _token) { //помещаем в token ссылка на наш контракт
        token = _token;
        owner = msg.sender;
    }

    modifier onlyOwner() { //проверка на хозяина контракта
        require(msg.sender == owner, "Only owner!");
        _;
    }

    function balance() public view returns(uint) { //сколько денег на контракте у нас есть(не токенов)
        return thisAddr.balance;
    }

    function buy() public payable { //покупка 
        require(msg.value >= _rate(), "Incorrect sum"); //проверка сколько отправили нам ethers
        uint tokensAvailable = token.balanceOf(thisAddr); //проверка сколько всего доступно токенов для продажи на контракте
        uint tokensToBuy = msg.value / _rate(); //это сколько токенов хочет купить у нас пользователь
        require(tokensToBuy <= tokensAvailable, "Not enough tokens!"); //проверка на то что кол-во токенов которое хочет купить пользователь меньше или равное балансу токенов на контракте
        token.transfer(msg.sender, tokensToBuy);//перевести кол-во запрашиваемых токенов на адрес который это делает
        emit Bought(msg.sender, tokensToBuy); //порождает событие на какой адрес и какое кол-во токенов ушло
    }

    function sell(uint amount) public { //функция для продажи токенов
        require(amount > 0, "Tokens must be greater than 0"); //проверка что кол-во, которое хотим продать не 0 
        uint allowance = token.allowance(msg.sender, thisAddr); //владелец токенов должен подтвердить, что он хочет продать на свои токены на такой-то адрес
        require(allowance >= amount, "Wrong allowance"); //что токенов больше либо равно запрошенным
        token.transferFrom(msg.sender, thisAddr, amount); //здесь уже непосредственно говорим от кого и куда, какое кол-во токенов переводится
        payable(msg.sender).transfer(amount * _rate()); //сколько вернётся нам денег 
        emit Sell(msg.sender, amount);
    }

    function withdraw(uint amount) public onlyOwner { //функция для вывода денег с контракта, может делать только тот, кто его развернул
        require(amount <= balance(), "Not enough funds!"); //не можем списать денег больше чем есть
        payable(msg.sender).transfer(amount);
    }

    function _rate() private pure returns(uint) { //устанавливаем стоимость 1 токена
        return 1 ether;
    }

    fallback() external payable {}

    receive() external payable {}
}