// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Sample {
    //enums 
    enum States { Started, Paid, Delivered, Recived }

    States public currentStatus;

    function demo() public {
        currentStatus = States.Paid;
    }
}