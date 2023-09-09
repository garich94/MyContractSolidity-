//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract WalletReentrancy {
    mapping(address => uint) public balances;

    function deposit(address _to) public payable {
        balances[_to] = balances[_to] + msg.value;
    }

    function balanceOf(address _who) public view returns (uint balance) {
        return balances[_who];
    }

    function withdraw() public {
        uint _amount = balances[msg.sender];
        if (balances[msg.sender] >= _amount) {
            (bool result, ) = msg.sender.call{value: _amount}("");
            require(result, "External call returned false");
            balances[msg.sender] = 0;
        }
    }

    receive() external payable {}
}
