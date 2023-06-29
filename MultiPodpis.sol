// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

//это будет смарт-контракт на который можно присылать средства, затем в рамках этого контракта можно ставить в очередь 
//выполнение транзакции, но чтобы эта транзакция была запущена, её должны подтвердить несколько человек нашего смарт-контракта

contract Ownable {
    address[] public owners; //массив владельцев
    mapping(address => bool) public isOwner; //чтобы посмотреть является ли адрес владельцем

    constructor(address[] memory _owners) {
        require(_owners.length > 0, "no owners!");
        for(uint i; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "zero address!");
            require(!isOwner[owner], "not unique!");  //проверка, что все переданные владельцы в массиве не повторяются
            
            owners.push(owner);
            isOwner[owner] = true;
        }
    }

    modifier onlyOwners() {
        require(isOwner[msg.sender], "not an owner!");
        _;
    }
}

contract MultiSig is Ownable {
    uint public requireApprovals; //нужное количество подтверждений 

    struct Transaction { //транзакция поставленная в очередь
        address _to;
        uint _value;
        bytes _data;
        bool _executed;
    }

    Transaction[] public transactions; //массив всех транзакций
    mapping(uint => uint) public approvalsCount;  //ключ будет номер транзакции в массиве, значением будет выступать количество подтверждений
    mapping(uint => mapping(address => bool)) public approved; //для того чтобы конкретно узнать, кто уже пописал нашу транзакцию, а кто нет


    event Deposit(address _from, uint _amount);//событие о том что средства пришли
    event Submit(uint _txId);
    event Approve(address _owner, uint _txId);
    event Revoke(address _owner, uint _txId);
    event Executed(uint _txId);

    constructor(address[] memory _owners, uint _requireApprovals) Ownable(_owners) {
        require(
            _requireApprovals > 0 && _requireApprovals <= _owners.length, 
            "invalid approvals count!"
        );
        requireApprovals = _requireApprovals;
    }

    function submit(address _to, uint _value, bytes calldata _data) external onlyOwners { //эта функция, когда мы хотим поставить транзакцию в очередь, на выполнение 
        Transaction memory newTx = Transaction({
            _to: _to,
            _value: _value,
            _data: _data,
            _executed: false
        });
        transactions.push(newTx);
        emit Submit(transactions.length - 1);
    }

    function encode(string memory _func, string memory _arg) public pure returns(bytes memory) {
        return abi.encodeWithSignature(_func, _arg);
    }

    modifier txExists(uint _txId) { //модификатор проверяет существует ли транзакция
        require(_txId < transactions.length, "not exist");
        _;
    }

    modifier notApproved(uint _txId) { //что транзакция уже, не была подтверждена
        require(!_isApproved(_txId, msg.sender), "tx already approved");
        _;
    }

    modifier notExecuted(uint _txId) { //проверка, что транзакция ещё не была выполнена
        require(!transactions[_txId]._executed, "tx alreay executed");
        _;
    }

    modifier wasApproved(uint _txId) {
        require(_isApproved(_txId, msg.sender), "tx not yet approved.");
        _;
    }

    modifier enoughApprovals(uint _txId) { //проверка что подтвеждений траназкций должно быть в нужном количестве
        require(approvalsCount[_txId] >= requireApprovals, "not enough approvals");
        _;
    }

    function _isApproved(uint _txId, address _addr) private view returns(bool) {
        return approved[_txId][_addr];
    }

    function approve(uint _txId) //функция для подтверждения
        external 
        onlyOwners
        txExists(_txId) //проверить, что такая транзакция вообще существует 
        notApproved(_txId) //проверка, что такая транзакция уже было не подтверждена
        notExecuted(_txId) //проверка, что такая транзакция не была уже выполнена
    {
            approved[_txId][msg.sender] = true;
            approvalsCount[_txId] += 1;
            emit Approve(msg.sender, _txId);
    }

    function revoke(uint _txId) //функция чтобы отозвать своё разрешение для запуска траназакции 
        external 
        onlyOwners
        txExists(_txId) // проверка, что траназакция уже существует
        notExecuted(_txId) //проверка, что траназакция не была уже выполнена
        wasApproved(_txId) //проверка, что данный адрес эту траназакцию уже подтверждал
        {
            approved[_txId][msg.sender] = false;
            approvalsCount[_txId] -= 1; //уменьшим общее кол-во разрешений
            emit Revoke(msg.sender, _txId);
    }

    function deposit() public payable { //функция которая может принимать денежные средства, чтобы в будущем мы могли перечислять эти средства на другие контракты
        emit Deposit(msg.sender, msg.value);
    }

    function execute(uint _txId) //функция, которая позволит выполнить транзакцию
        external 
        txExists(_txId) //проверка, что транзакция должна существовать
        notExecuted(_txId) //траназакция не должна быть уже выполнена
        enoughApprovals(_txId) { //должна быть достаточное кол-во подтверждений
            Transaction storage myTx = transactions[_txId]; //берём нашу траназкцию из массива с транзакциями

            (bool success,) = myTx._to.call{value: myTx._value}(myTx._data);
            require(success, "tx failed");

            myTx._executed = true;
            emit Executed(_txId);
    }

    receive() external payable {
        deposit();
    }
}

contract Receiver { //тест контракт он будет принимать денежные средства 
    string public message;

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function getMoney(string memory _msg) external payable {
        message = _msg;
    }
}