// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IERC20 {
    function decimals() external pure returns(uint);

    function totalSupply() external view returns(uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address to, uint amount) external returns(bool);

    function allowance(address owner, address spender) external view returns(uint);

    function approve(address spender, uint amount) external returns(bool);

    function transferFrom(address from, address to, uint amount) external returns(bool);

    event Transfer(address indexed from, address indexed to, uint value);

    event Approval(address indexed owner, address indexed spender, uint value);
}

contract ERC20 is IERC20 {
    uint totalTokens;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) public allowances;
    string public name = "SashkaCoin";
    string public symbol = "SCT";

    constructor(string memory _name, string memory _symbol, uint initialSupply) {
        name = _name;
        symbol = _symbol;
        mint(initialSupply);
    }

    modifier enoughTokens(address _from, uint _amount) {
        require(balanceOf(_from) >= _amount, "Not enough tokens!");
        _;
    }

    function decimals() public pure returns(uint) {
        return 18;
    }

    function totalSupply() public view virtual override returns(uint) {
        return totalTokens;
    }

    function balanceOf(address account) public view virtual override returns(uint) {
        return balances[account];
    }

    function transfer(address to, uint amount) external enoughTokens(msg.sender, amount) returns(bool) {
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function allowance(address owner, address spender) public view returns(uint) {
        return allowances[owner][spender];
    }

    function approve(address spender, uint amount) public returns(bool) {
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint amount) public enoughTokens(from, amount) returns(bool) {
        allowances[from][msg.sender] -= amount;
        balances[from] -= amount;
        balances[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }

    function mint(uint amount) public {
        balances[msg.sender] += amount;
        totalTokens += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint amount) internal enoughTokens(msg.sender, amount) {
        balances[msg.sender] -= amount;
        totalTokens -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}

contract Weth is ERC20 { //будет следовать из контракта ERC20
    constructor() ERC20("WrappedEther", "WETH", 0) {}
    
    event Deposit(address indexed initiator, uint amount);//добавили депозит(конвертировали средства)
    event Withdraw(address indexed initiator, uint amount);//вывели средства с контракта

    function deposit() public payable {
        mint(msg.value); //что наш адрес получается какое-то кол-во конвертнутых ETH;
        emit Deposit(msg.sender, msg.value);//событие что нам конвернтули eth
    }

    receive() external payable {
        deposit();
    }

    function withdraw(uint _amount) public { //меняем токены на настоящий эфир, и выводим данные токены из оборота 
        burn(_amount);
        (bool success, ) = msg.sender.call{value: _amount}(""); //возврщаем наши токены ETH
        require(success, "Failed");
        emit Withdraw(msg.sender, _amount);
    }
}
