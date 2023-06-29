// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC20.sol";

contract StakingAlg {
    IERC20 public rewardsToken;  //токены которые будут начисляться в награду(реварды)
    IERC20 public stakingToken; //токены, которые положили в стейкинг

    uint public rewardRate = 10; //какую награду будем получать в зависимости от времени
    uint public lastUpdateTime; //когда последний раз обновляли информацию о награде, которую должен получить юзер
    uint public rewardPerTokenStored; //сколько награды платить за каждый токен лежащий на контракте

    mapping(address => uint) public userRewardPerTokenPaid; //инфа о том сколько заплатили пользователю за каждый токен
    mapping(address => uint) public rewards; //выплаченное вознаграждение, которое пользователь должен получить

    mapping(address => uint) private _balances; //балансы разных адресов
    uint private _totalSupply; //сколько всего токенов есть на данном контракте 

    constructor(address _stakingToken, address _rewardsToken) {
        stakingToken = IERC20(_stakingToken); //контракт IERC20 реализует интерфейс данного токена
        rewardsToken = IERC20(_rewardsToken); //контракт IERC20 реализует интерфейс данного токена
    }

    modifier updateReward(address _account) { //модификатор для пересчёта награды, которую должен получить конкретный аккаунт 
        rewardPerTokenStored = rewardPerToken(); //сколько нужно заплатить за каждый токен, который лежит на балансе данного смарт-контракта
        lastUpdateTime = block.timestamp; //так как наша награда зависит от времени сколько лежат наши токены в контракте потребуется такая переменная 
        rewards[_account] = earned(_account); //то сколько заработал данный аккаунт, на данный момент времени
        userRewardPerTokenPaid[_account] = rewardPerTokenStored; //
        _;
    }

    function rewardPerToken() public view returns(uint) { //вычисляем размер награды за каждый токен котоырй мы держим на смарт-контракте
        if(_totalSupply == 0) {
            return 0;
        }

        return rewardPerTokenStored + 
        (rewardRate * (block.timestamp - lastUpdateTime)
        ) * 1e18 / _totalSupply;
    }

    function earned(address _account) public view returns(uint) { //
        return (
            _balances[_account] * (
                rewardPerToken() - userRewardPerTokenPaid[_account]
            ) / 1e18
        ) + rewards[_account]; //мы считаем сколько уже надо было выполнить данному аккаунту и смотрим сколько уже запросшедшее время данный аккаунт уже заработал 
    }

    function stake(uint _amount) external updateReward(msg.sender) { //положить, какое-то кол-во токенов на данный смарт-контракт
        _totalSupply += _amount; //увеличилось кол-во токенов на данном адресе
        _balances[msg.sender] += _amount; //записываем в мэппинг, сколько прибавилось токенов на данном адресе
        stakingToken.transferFrom(msg.sender, address(this), _amount); //забираем у инициатора транзакции столько токенов, сколько он указал
    }

    function withdraw(uint _amount) external updateReward(msg.sender) { //забрать с этого смарт-контракта свои токены
        require(_balances[msg.sender] >= _amount, "there are not enough funds on your balance");
        _totalSupply -= _amount; //уменьшается кол-во токенов, относительно всего контракта 
        _balances[msg.sender] -= _amount; //уменьшается кол-во токенов относительно нашего адреса
        stakingToken.transfer(msg.sender, _amount); //списываем нужное кол-во токенов на наш адрес
    } 

    function getReward() external updateReward(msg.sender) { //функция забирает награду за те токены, что лежат на контракте
        uint reward = rewards[msg.sender]; //сколько награды полагается на текущей момент времени на конкретный адрес
        rewards[msg.sender] = 0;
        rewardsToken.transfer(msg.sender, reward); //выводим всю сумму на адрес, котрому полагается данная награда
    }
}