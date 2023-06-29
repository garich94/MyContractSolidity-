//SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

import "./Factory.sol";

contract Offer {
    enum RentalStatus {Free, Busy, Dispute} // статусы нашей аренды
  
    RentalStatus public status; // кастомная переменная, которая меняет статус аренды
    uint public id; // id данного оффера
    address public landlord; // хозяин оффера 
    address public owner; // хозяин фабрики Офферов
    uint public price; // стоимость проживания в месяц утверждённому арендатору
    uint public constant FACTORY_COMISSION = 1; // комиссия фабрики 1%
    // uint public is_rented;   
    uint public min_price; // минимальная прайс
    uint public rented_till; // срок проживания расчитывается после апрува
    address public rented_by; // адрес арендатора, который будет арендовать жильё
    uint public min_deposit; // минимальный депозит

    address[] public rentersAddr; // массив адресов арендаторов

    struct Renters { // инфа о том кто пытается арендовать 
        uint price; // предложенная цена
        uint deposit; // внесённый на контракт депозит
        bool rented; // булево значение меняется, если арендодатель решил именно данному пользователю сдать жильё
    }

    mapping(address => Renters) public rentersInfo; // мэппинг который хранит стуктуру по каждому адресу арендатора

    constructor(uint _id, uint _min_price, uint _min_deposit) {
        id = _id;
        status = RentalStatus.Free;
        min_price = _min_price;
        owner = msg.sender; 
        landlord = tx.origin; 
        min_deposit = _min_deposit;   
    }

    modifier not_rented { // проверка, что квартира не арендована
        require(status == RentalStatus.Free, "The apartment is already booked.");
        _;
    }

    modifier only_landlord { // модификатор проверик, что только landlord может выполнить ту или иную функцию
        require(landlord == msg.sender, "Can only execute landlord.");
        _;
    }

    modifier only_renter { // модификатор, говорит о том что только действующий арендатор может воспользоваться даннйо функцией
        require(msg.sender == rented_by && rentersInfo[msg.sender].rented == true, "only the current tenant can call the function.");
        _;
    }

    event RentedHousing(address indexed rented_by, uint indexed rentalPeriod, uint indexed rentalPrice); // событие когда landlord делает апрув или пользователь продлевает аренду 

    event RenterMadeBat(address indexed renterAddr, uint indexed renterPrice, uint indexed renterDeposit); // событие порождается, когда какой-то пользователь делает ставку

    event RefundOfFund(address indexed refundAddr, uint indexed amountDeposit, uint indexed amountComission); // событие порождается, когда происходит возврат средств

    function rent(uint _price, uint _deposit) public not_rented payable {
        require(_deposit == msg.value, "You have entered the wrong deposit amount."); // проверка равен ли указанный депозит переводимым средствам
        // require(_deposit > _price, "The deposit entered must be more than the price."); // депозит всегда должен быть больше прайса
        require(rentersInfo[msg.sender].price >= min_price  || _price >= min_price, "Your price must be higher or equal to the minimum price."); // указанный прайс должен превышать либо быть равен минимальному прайсу
        require(rentersInfo[msg.sender].deposit >= min_deposit || _deposit >= min_deposit, "Your deposit must be above or equal to the minimum deposit."); // указанный депозит должен быть равен или больше минимального депозита

        rentersAddr.push(msg.sender); // добавляем адрес в массив адресов претендующих на аренду


        uint rentPrice = rentersInfo[msg.sender].price += _price; // добавляем прайс в стуктуру и делаем её локальной переменной 
        uint rentDeposit = rentersInfo[msg.sender].deposit += _deposit;  // добавляем депозит в стуктуру  и делаем её локально переменной

        (bool success, ) = address(this).call{value: msg.value}(""); // передаём на адрес оффера, средства депозита

        require(success, "Failed!"); // проверка, что низкоуровневый вызов прошёл успешно

        emit RenterMadeBat(msg.sender, rentPrice, rentDeposit); // вызываем событие, когда рентор делает ставку 
    }

    function approve(address _renter) public only_landlord not_rented {
        require(msg.sender != _renter && _renter != address(0), "you can't rent a place by yourself!"); // проверка предовращает, чтобы сам арендодатель не смог снять у себя жильё
        require(rentersInfo[_renter].deposit >= min_deposit, "the deposit is too small!"); // проверяем чтобы депозит того пользователя которого мы апруваем, был больше минимального

        rented_by = _renter; //адрес нашего арендодателя
        rented_till = block.timestamp + 30 days; // когда заканчивается срок аренды в 1 месяц
        price = rentersInfo[rented_by].price; // меняем стейт переменную, актуальная стоимость месячной аренды для данного арендатора
        

        for(uint i = 0; i < rentersAddr.length; i++) {
            if(rentersAddr[i] != rented_by) { // проверяем что адрес из массива не является выбранным арендатором
               
                address renterAddr = rentersAddr[i]; // делаем локальную переменную данного адреса в цикле
                uint comissionFactory = rentersInfo[_renter].deposit * FACTORY_COMISSION / 100; // делаем локальную переменную с нашей комисиией для фабрики
                uint balanceRenter = rentersInfo[renterAddr].deposit - comissionFactory; // делаем локальную переменную депозита данного адреса
                rentersInfo[renterAddr].deposit = 0; // зануляем депозит данного адреса во избежание атаки reentrancy
                rentersInfo[renterAddr].price = 0; // зануляем прайс
                
                payable(renterAddr).transfer(balanceRenter); // отправляем депозиты на адреса пользователей которым не удалось арендовать
                (bool success, ) = owner.call{value: comissionFactory}(""); // отправляем нашей фабрике комиссию от вложенного депа
                require(success, "Failed!"); // проверяем прошла ли транзакция

                emit RefundOfFund(renterAddr, balanceRenter, comissionFactory); // событие в котором сообщается, кому возвращются средства, в каком количестве, и сколько составила комиссия за участие
            } else {
                

                uint comissionFactoryRented = price * FACTORY_COMISSION / 100; // в данном случае берём комиссию с каждого платежа за ежемесячную оплату а не со всего деопозита 
                rentersInfo[_renter].deposit -= (price + comissionFactoryRented); // вычитаем плату за месяц из депозита нашего арендодателя
                status = RentalStatus.Busy; // меняем статус нашего жилья
                rentersInfo[_renter].rented = true; // меняем флажок на true в структуре, тем самым показываем, что нашему пользователю удалось забронировать жильё 
                
                payable(landlord).transfer(price); // отправляем прайс за месяц на адрес landlord

                (bool success, ) = owner.call{value: comissionFactoryRented}(""); // отправляем комиссию от прайса на адрес фабрики
                require(success, "Failed!"); // проверка на то прошла ли комиссия на адрес фабрики

                emit RentedHousing(rented_by, rented_till, price); // порождаем событие в котором говорится кто арендовал на какой срок, и какой прайс в месяц 
            }
        }
        delete rentersAddr; // удаляем с нашего массива все адреса
    }

    function returnArray() public view returns(address[] memory) { // функция помошник, смотрел будет ли массив пустым после цикла 
        return rentersAddr;
    }

    function cancel() external not_rented { // функция, которая позволяет вернуть средства, если помещение ещё не арендовано 
        require(rentersInfo[msg.sender].deposit >= min_deposit, "your deposit is less than the established minimum."); // проверка, на то есть ли вообще средства у пользователя на данном контракте, который вызвал функцию

        uint balanceRenter = rentersInfo[msg.sender].deposit; // делаем локальную переменную с которая отображает депозит пользователя

        rentersInfo[msg.sender].deposit = 0; // зануляем депозит во избежание атаки реентранси
        rentersInfo[msg.sender].price = 0; // зануляем прайс

        payable(msg.sender).transfer(balanceRenter); // переводим средства пользователю

        emit RefundOfFund(msg.sender, balanceRenter, 0); // порождаем событие в котром отобоажается адрес, и размер выведенного депозита
    }

    function reRent() external only_renter {  // функция для продления аренды ещё на месяц, действующим арендатором
        require(rentersInfo[msg.sender].deposit >= price, "there is not enough deposit for the next rental."); // проверяем, что оставшийся депозит больше или равен прайсу за месяц

        rented_till += 30 days; // добавляем к нашему сроку аренды ещё 30 дней

        uint comissionFactoryRented = price * FACTORY_COMISSION / 100; // в данном случае берём комиссию с каждого платежа за ежемесячную оплату а не со всего деопозита 
        rentersInfo[msg.sender].deposit -= (price + comissionFactoryRented); // вычитаем из нашего депозита прайс за месяц 
        payable(landlord).transfer(price); // отправляем прайс за месяц на адрес landlord

        (bool success, ) = owner.call{value: comissionFactoryRented}(""); // отправляем комиссию от прайса на адрес фабрики
        require(success, "Failed!"); // проверка на то прошла ли комиссия на адрес фабрики

        emit RentedHousing(rented_by, rented_till, price); // порождаем событие в котором говорится кто арендовал на какой срок, и какой прайс в месяц 
    }

    function break_contract() external only_renter { // функция, принудительно завершает аренду раньше срока по желанию арендатора
        require(rentersInfo[msg.sender].deposit > 0, "your balance is zero!");
        uint balanceRenterBreak = rentersInfo[msg.sender].deposit; // делаем локальную переменную с оставшимся депозитом нашего арендатора
        require(balanceRenterBreak <= address(this).balance, "balance contract little deposit");

        rentersInfo[msg.sender].deposit = 0; // зануляем депозит арендатора
        rentersInfo[msg.sender].price = 0; // зануляем price арендатора
        rentersInfo[msg.sender].rented = false; // меняем флажок в структуре 

        rented_by = address(0); // зануляем адрес арендатора
        rented_till = 0; // зануляем время аренды 
        price = 0; // зануляем прайс котоырй был на срок аренды

        status = RentalStatus.Free; // меняем статус нашего помещения на свободное

        payable(msg.sender).transfer(balanceRenterBreak); // отправляем средства нашему пользователю

        emit RefundOfFund(msg.sender, balanceRenterBreak, 0); // породили событие что вернули нашему арендатору средства 
    }

    receive() external not_rented payable { // контракт может принимать средства только тогда, когда квартира свободна
    }
}

contract Demo {
    function cislo() public pure returns(uint8) {
        uint chislo = 1;
        return uint8(chislo);
    }
}




