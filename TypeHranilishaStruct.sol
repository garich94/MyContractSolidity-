// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Demo {
    struct Person {
        uint age;
        string name;
    }

    mapping(uint => Person) public users;

    constructor() {
        Person memory newPerson = Person({ age: 30, name: 'John'});
        users[0] = newPerson;
    }

    function demo() public {
        Person storage myPerson = users[0];
        myPerson.age++;
    }    
}