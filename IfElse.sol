// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract TransactionStatus {
    uint public price = 20;

    function payment(uint _payment) public view returns (string memory) {

        if(price == _payment) {
            return 'Payment successful';
        } else if (price > _payment) {
            return 'Decline not sufficient funds';
        } else {
            return 'Payment error';
        }
    }
}