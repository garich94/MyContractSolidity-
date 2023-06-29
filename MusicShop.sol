// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MusicShop {
    struct Album {
        uint index; // индекс нашего альбома
        string uid; // идентификатор
        string title; // название альбома
        uint price; // цена
        uint quantity; // кол-во альбомов
    }

    struct Order { // заказ
        string albumUid; // какой альбом был заказан
        address customer; // кто заказал альбом
        uint orderedAt; // 
        OrderStatus status; // статус заказа
    }

    enum OrderStatus { Paid, Delivered } // состояние 

    Album[] public albums; // массив всех альбомов
    Order[] public orders; 

    uint currentIndex; // для отслеживания текущего индекса

    address public owner;

    modifier  onlyOwner() {
        require(msg.sender == owner, "not an owner!");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addAlbums(string calldata uid, string calldata title, uint price, uint quantity) external onlyOwner {
        albums.push(Album({
            uid: uid,
            title: title,
            price: price,
            quantity: quantity
        }));

        currentIndex++ ;
    }

    function buy(uint _index) external payable { //функция для покупки какого-то альбома
        Album storage albumToBuy = albums[_index];
        require(msg.value == albumToBuy.price, "invalid price");
        require(albumToBuy.quantity > 0, "out of stock!");

        albumToBuy.quantity--;
        
        orders.push(Order({
            albumUid: albumToBuy.uid,
            customer: msg.sender,
            orderedAt: block.timestamp,
            status: OrderStatus.Paid
        }));
    }

    function allAblums() external view returns(Album[] memory) { // функция, чтобы смотреть какие альбомы вообще у нас есть
        Album[] memory albumsList = new Album[](albums.length);

        for(uint i = 0; i < albums.length; i++) {
            albumsList[i] = albums[i];
        }

        return albumsList;
    }
}