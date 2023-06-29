//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

contract Timelock {
    address public owner; //концепция владельца контракта

    uint public constant MIN_DELAY = 10; //минимально допустимая задержка для выполнения транзакции
    uint public constant MAX_DELAY = 100; //максимально допустимая задержка
    uint public constant EXPIRY_DELAY = 1000; //спустя какое время транзакция считается истёкшей

    mapping(bytes32 => bool) public queuedTxs;
    //bytes32 - идентификатор транзакции 
    //bool - поставлена ли эта транзакция в очередь или нет

    event Queued(
        bytes32 indexed txId,
        address indexed to,
        uint value,
        string func,
        bytes data,
        uint timestamp
    );

    event Executed(
        bytes32 indexed txId,
        address indexed to,
        uint value,
        string func,
        bytes data,
        uint timestamp
    );

    constructor() { //задаём владельца контракта
        owner = msg.sender;
    }

    modifier onlyOwner() { //проверка на владельца контракта
        require(msg.sender == owner, "not an owner");
        _;
    }

    function queue( //функция для того чтобы поставить, что-то в очередь
        address _to, //куда отправляем данную транзакцию
        uint _value, //будут ли какие-то денежные средства или нет
        string calldata _func, //имя той функции с которой мы хотим взаимодействовать 
        bytes calldata _data, //данные функции, то есть аругмент
        uint _timestamp // метка времени, когда хотим это всё выполнить
    ) external onlyOwner returns(bytes32) {
        bytes32 txId = keccak256(
            abi.encode( //здесь получаем уникальный идентификатор транзакции
                _to, _value, _func, _data, _timestamp // кодируем в байт-код все наши входящие данные
            )
        );
        require(!queuedTxs[txId], "already queued!"); //проверка, что такая транзакция уже в очереди не стоит
        require(
            _timestamp >= block.timestamp + MIN_DELAY &&
            _timestamp <= block.timestamp + MAX_DELAY,
            "invalid timestamp"
        );
        queuedTxs[txId] = true;
        emit Queued(
            txId,
            _to,
            _value,
            _func,
            _data,
            _timestamp
        );

        return txId;
    }

    function execute(
        address _to, 
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
    ) external payable onlyOwner returns(bytes memory) {
        bytes32 txId = keccak256(
            abi.encode(
                _to, _value, _func, _data, _timestamp
            )
        );

        require(queuedTxs[txId], "not queued!"); //проверка была ли наша транзакция поставлена в очередь
        require(block.timestamp >= _timestamp, "too early!"); //проверка, наступило ли время для исполнения нашей транзакции
        require(block.timestamp <= _timestamp + EXPIRY_DELAY, "too late!"); //проверка, чтобы не возникла ситуациия, что наша тразакция могла быть выполнена давно, если слишком долго ждали, транзакция считается уже устаревшей её выполнить нельзя

        delete queuedTxs[txId]; //если все проверки пройдены мы удаляем транзакцию из нашего мэппинга

        bytes memory data; //нужно правильно закодировать имя функции и данные, чтобы потом это всё отправить в транзакции 
        if(bytes(_func).length > 0) {
            data = abi.encodePacked(
                bytes4(keccak256(bytes(_func))), _data //нужно взять у функции, первые 4 байта её хэша, чтобы по ним идентифицировать в будущем нашу функцию
            );
        } else { // если имя функции не указано берём просто data, а data это изначально уже байты
            data = _data;
        }

        (bool success, bytes memory resp) = _to.call{value: _value}(data); //call вернёт кортеж из двух значений bool и bytes

        require(success, "tx failed!");

        emit Executed(
            txId,
            _to,
            _value,
            _func,
            _data,
            _timestamp
        );

        return resp;
    }

    function cancel(bytes32 _txId) external onlyOwner { //функция с помощью которой отменяем транзакцию 
        require(queuedTxs[_txId], "not queued!");

        delete queuedTxs[_txId];
    } 
}

contract Runner { //тестирует наш функционал нашего контракта 
    address public lock; //адрес нашего смарт-контракта 
    string public message;
    mapping(address => uint) public payments; //мэппинг с платежами 

    constructor(address _lock) {
        lock = _lock;
    }

    function run(string memory newMsg) external payable {
        require(msg.sender == lock, "invalid address");

        payments[msg.sender] += msg.value;
        message = newMsg;
    }

    function newTimestamp() external view returns(uint) { // чтобы посчиать то время, которое будем передавать в контракт в timestamp
        return block.timestamp + 20;
    }  

    function prepareDate(string calldata _msg) external pure returns(bytes memory) { // 
        return abi.encode(_msg);
    }
}