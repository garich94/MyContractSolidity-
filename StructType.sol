// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Sample {
    address myAddr = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    uint public amount;
    //struct
    struct Payment {
        address senderAddr;
        uint amount;
    }

    

    Payment[] public payments;

    function demo() public {
        Payment memory newPayment = Payment(myAddr, 42);
        payments.push(newPayment);

        amount = newPayment.amount;
    }
}