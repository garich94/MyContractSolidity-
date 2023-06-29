// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./SharedWallet.sol";

contract Wallet is SharedWallet {
    event MoneyWithdrawn(address indexed _to, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function withdrawMoney(uint _amount) external ownerOrWithinLimits(_amount)  {
        require(_amount <= getBalance(), "not enough funds!");

        if(!isOwner()) {
            deduceFromLimit(msg.sender, _amount);
        }

        payable(msg.sender).transfer(_amount);

        emit MoneyWithdrawn(msg.sender, _amount);
    }

    fallback() external payable {}
    receive() external payable {
        emit MoneyReceived(msg.sender, msg.value);
    }

}