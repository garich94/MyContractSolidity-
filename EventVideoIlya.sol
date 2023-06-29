// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Demo {
    event MoneyTransfered(address _to, uint _amount);

    function withdraw(address payable _to) public {
        address thisContract = address(this);
        uint amount = thisContract.balance;

        _to.transfer(amount);

        emit MoneyTransfered(_to, amount);
    }
}