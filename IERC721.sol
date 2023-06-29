//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IERC721 {
    event Transfer(address indexed from, address indexed to, uint indexed tokenId); // когда было передано владение от одного к другому 
    event Approval(address indexed owner, address indexed approved, uint indexed tokenId); // разрешение на распоряжение нашим токеном ERC721
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved); // событие говорит, что мы определённому адресу разрешаем, распоряжатся всеми нашими NFT

    function balanceoOf(address owner) external view returns(uint); //проверка сколько NFT у нас всего есть

    function ownerOf(uint tokenId) external view returns(address); // кто владеет наш данным NFT

    function safeTransferFrom( //безопасная передача NFT, может делать только тот кому это разрешили сделать
        address from,
        address to,
        uint tokenId,
        bytes calldata data // для проброски данных 
    ) external;

    function safeTransferFrom( //безопасная передача NFT, может делать только тот кому это разрешили сделать
        address from,
        address to,
        uint tokenId
    ) external;

    function transferFrom( // небезопасный перевод 
        address from, 
        address to,
        uint tokenId
    ) external;

    function approve( // функция для разрешения определённым адресам распоряжатся нашими NFT
        address to,
        uint tokenId
    ) external;

    function setApprovalForAll( // разрешает определённому адресу распоряжатся всеми нашими NFT сразу
        address operator,
        bool approved
    ) external;

    function getApproved( // функция, которая проверяет было ли выдано разрешение на распоряжение управления токенами или нет
        uint tokenId
    ) external view returns(address);

    function isApprovedForAll( // функция которая проверяет, можно ли данному оператору управлять токенами владельца, которые передаются в аргументах функции
        address owner,
        address operator
    ) external view returns(bool);
}