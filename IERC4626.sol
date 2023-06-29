// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC20.sol";

interface IERC4626 is ERC20, {
    event Deposit(
        address indexed sender,
        address indexed owner,
        uint assets,
        uint shares
    );

    event Withdraw(
        address indexed sender,
        address indexed receiver,
        address indexed owner,
        uint assets,
        uint shares
    );

    function asset() external view returns(address assetsTokenAddress); //asset это указание на то что можно вкладывать в данный контракт

    function totalAssets() external view returns(uint totalManagedAssets); //сколько есть в храналище токенов, которые вкладывают

    function convertToShares(uint assets) external view returns(uint shares); //функция говорит, сколько токенов человек хочет вложить, и сколько долей других токенов мы ему выдадем 

    function convertToAssets(uint shares) external view returns(uint assets); //фукнция говорит, о том сколько я хочу погасить долей и сколько своих токенов обратно я получу

    function maxDeposit(address receiver) external view returns(uint maxAssets); //функция говорит о том, сколько максимум можно вложить 

    function previewDeposit(uint assets) external view returns(uint shares); //сколько будет сминчено токенов за наше вложение

    //кладёт укащанное кол-во токенов, создаёт n-ное кол-во долей
    function deposit(uint assets, address receiver) external returns(uint shares);

    function maxMint(address receiver) external view returns(uint maxShares); //сколько максимум за раз можно получить долей

    function previewMint(uint shares) external view returns(uint assets);


    //создаёт указанное кол-во долей, высчитывает сколько токенов нужно взять 
    //у юзера, который функцию вызвал 
    function mint(uint shares, address receiver) external returns(uint assets);

    function maxWithdraw(address owner) external view returns(uint maxAssets); //говорит о том сколько максимум можно вывести своих токенов

    function previewWithdraw(uint assets) external view returns(uint shares); //читабельная функция, которая просто говорит сколько можно вывести за определённое кол-во долей 

    // возвращает указанное кол-во токенов, сжигает соответствующее кол-во долей
    function withdraw(uint assets, address receiver, address owner) external returns(uint shares);

    function maxRedeem(address owner) external view returns(uint maxShares);

    function previewRedeem(uint shares) external view returns(uint assets);

    // сжигает ровно указанное кол-во долей, возвращает некоторое кол-во токенов
    // в соотвествии с этими долями

    function redeem(uint shares, address receiver, address owner) external returns(uint assets);
}