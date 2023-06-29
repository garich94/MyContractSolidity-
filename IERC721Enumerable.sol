// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC721.sol";

interface IERC721Enumerable is IERC721 {
    function totalSupply() external view returns(uint); // сколько всего токенов NFT есть

    function tokenOfOwnerByIndex(address owner, uint index) external view returns(uint); // у владельца может быть много токенов, функция будет возвращать конкретный токен по индексу из массива

    function tokenByIndex(uint index) external view returns(uint); // возвращаем токен по конкретному индексу из массива токенов, которые вообще у нас есть

    
}