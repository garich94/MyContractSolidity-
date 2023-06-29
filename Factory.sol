//SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

import "./Offer.sol";

contract Factory {
    address public ownerFactory; // создатель фабрики задаётся в конструкторе 
    uint[] public offersId; // массив if офферов 
    mapping(uint => OfferStr) public idStructOffer; // мапинг, который по уникальному id выдаёт стурктуру наших офферов

    constructor() { // задаём в конструкторе хозяина фабрики
        ownerFactory = msg.sender;
    }

    modifier onlyOwnerFactory {
        require(msg.sender == ownerFactory, "The function can only be called by the factory creator.");
        _;
    }

    event CreateNewOffer(address indexed addrNewOffer, uint indexed min_price, uint indexed min_deposit); // событие порождается при создании нового оффера

    struct OfferStr {
        address offer; // адрес оффера
        uint min_price; // установленный минимальный прайс нашего оффера
        uint min_deposit; // установленный минимальный деозит нашего оффера
    }
    
    function create_offer(uint _id, uint _min_price, uint _min_deposit) public { // функция создания нового оффера
        require(tx.origin == msg.sender, "The landlord cannot be a smart contract!"); // делаем проверку, чтобы создатель нашего оффера не был смарт-контрактом
        require(idStructOffer[_id].offer == address(0), "An object with this id already exists!"); // делаем проверку, что оффера с данным id ещё не создавали
        Offer newOffer = new Offer(_id, _min_price, _min_deposit); // создаём новый оффер
        idStructOffer[_id].offer = address(newOffer); // кладём в структуру адрес оффера
        idStructOffer[_id].min_price = _min_price; // кладём в структуру минимальный прайс
        idStructOffer[_id].min_deposit = _min_deposit; // кладём в структуру минимальный депозит
        offersId.push(_id); // добавляем id в массив
        emit CreateNewOffer(address(newOffer), _min_price, _min_deposit); // порождаем событие в котором говорим, что с каким адресом был создан новый оффер, какой минимальный прайс, минимальный депозит
    }

    // function get_idStructOffer(uint _id) public view returns(OfferStr memory) { // функция помошник читаем стуркутру оффера по id
    //     return idStructOffer[_id];
    // }

    // function get_offersIdAddr(uint _id) public view returns(address) { // функция помошник читаем  оффера по id
    //     return idStructOffer[_id].offer;
    // }

    function get_offersId() public view returns(uint[] memory) { // показывает весь наш массив с id 
        return offersId;
    }

    function withdrawComission(address _addr, uint _comissionWithdraw) public onlyOwnerFactory {
        require(_comissionWithdraw <= address(this).balance, "");
        payable(_addr).transfer(_comissionWithdraw);
    }

    receive() external payable {

    }
}
