// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Demo {
    bool alive = true;

    function pay() public payable {
        require(alive, "I'm dead");
    }

    function balance() public view returns(uint) {
        require(alive, "I'm dead");

        return address(this).balance;
    }

    function destroy() public {
        require(alive, "I'm dead");

        address payable _to = payable(msg.sender);
        _to.transfer(balance());
        alive = false;
    }
}