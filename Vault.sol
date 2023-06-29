//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC20.sol";

contract Vault {
    IERC20 public immutable token;
    uint public totalSupply;

    mapping(address => uint) public balanceOf;

    constructor(address _token) {
        token = IERC20(_token); //токен реализиует интерфейс ERC20
    }

     function withdraw(uint _shares) external { //вывести с данного контракта токены
        uint _amount = (_shares * token.balanceOf(address(this))) / totalSupply;

        burn(msg.sender, _shares);
        token.transfer(msg.sender, _amount);
    }

    function addr() public view returns(uint) {
        return token.balanceOf(address(this));
    }

    function deposit(uint _amount) external { // с помощью данной функции принимаем токены на счёт нашего контракта
        uint shares;
        if (totalSupply == 0) {
            shares = _amount;
        } else {
            shares = (_amount * totalSupply) / token.balanceOf(address(this));
        }

        mint(msg.sender, shares);
        token.transferFrom(msg.sender, address(this), _amount);
    }

    function mint(address _to, uint _shares) private {
        totalSupply += _shares;
        balanceOf[_to] += _shares;
    }

    function burn(address _from, uint _shares) private {
        totalSupply -= _shares;
        balanceOf[_from] -= _shares;        
    }
}