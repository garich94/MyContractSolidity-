import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("DeployContracts", function () {
  async function dep() {
    const [deployer, user1, user2] = await ethers.getSigners();

    const wallet = await ethers.deployContract("Wallet");

    await wallet.waitForDeployment();

    const txWallet = {
      to: wallet.target,
      value: ethers.parseEther("5.0"),
    };

    const txSendEthWallet = await user2.sendTransaction(txWallet);
    await txSendEthWallet.wait();

    const walletReentrancy = await ethers.deployContract("WalletReentrancy");

    await walletReentrancy.waitForDeployment();

    const txWalletReentrancy = {
      to: walletReentrancy.target,
      value: ethers.parseEther("5.0"),
    };

    const txSendEthWalletReentrancy = await user2.sendTransaction(
      txWalletReentrancy
    );
    await txSendEthWalletReentrancy.wait();

    const walletUnderflow = await ethers.deployContract("WalletUnderflow");

    await walletUnderflow.waitForDeployment();

    const txWalletUnderflow = {
      to: walletUnderflow.target,
      value: ethers.parseEther("5.0"),
    };

    const txSendEthWalletUnderflow = await user2.sendTransaction(
      txWalletUnderflow
    );

    await txSendEthWalletUnderflow.wait();

    const attacker = await ethers.deployContract(
      "Attacker",
      [wallet.target, walletReentrancy.target, walletUnderflow.target],
      user1
    );

    await attacker.waitForDeployment();

    const txAttacker = {
      to: attacker.target,
      value: ethers.parseEther("1.0"),
    };

    const txSendEthAttacker = await user1.sendTransaction(txAttacker);

    await txSendEthAttacker.wait();

    return {
      wallet,
      walletReentrancy,
      walletUnderflow,
      attacker,
      user1,
      user2,
      deployer,
    };
  }

  describe("Attack wallet", function () {
    it("attack wallet, revert transactions", async function () {
      const { wallet, attacker, user1 } = await loadFixture(dep);

      const depositWallet = attacker.connect(user1).depositWallet();
      await expect(depositWallet).to.changeEtherBalances(
        [attacker, wallet],
        [-ethers.parseEther("1.0"), ethers.parseEther("1.0")]
      );

      const attackWallet = attacker.connect(user1).attackWallet();
      await expect(attackWallet).to.be.revertedWith(
        "External call returned false"
      );

      expect(await ethers.provider.getBalance(attacker)).to.eq(0);
      expect(await ethers.provider.getBalance(wallet)).to.eq(
        ethers.parseEther("6.0")
      );
    });
  });

  describe("Attack walletReentrancy", function () {
    it("attacking a wallet with a reentrancy vulnerability", async function () {
      const { walletReentrancy, attacker, user1, user2 } = await loadFixture(
        dep
      );

      const depositWalletRe = attacker.connect(user1).depositWalletRe();
      await expect(depositWalletRe).to.changeEtherBalances(
        [attacker, walletReentrancy],
        [-ethers.parseEther("1.0"), ethers.parseEther("1.0")]
      );

      const revertWithdrawNoEthContract = attacker.connect(user1).withdrawEth();
      await expect(revertWithdrawNoEthContract).to.be.revertedWith(
        "there is no eth on the contract"
      );

      const attackWalletRe = attacker.connect(user1).attackWalletRe();
      await expect(attackWalletRe).to.changeEtherBalances(
        [walletReentrancy, attacker],
        [-ethers.parseEther("6.0"), ethers.parseEther("6.0")]
      );

      const withdrawEthAttackerNotOwner = attacker.connect(user2).withdrawEth();

      await expect(withdrawEthAttackerNotOwner).to.be.revertedWith(
        "not an owner!"
      );

      const withdrawEthAttackerOwner = attacker.connect(user1).withdrawEth();

      await expect(withdrawEthAttackerOwner).to.changeEtherBalances(
        [attacker, user1],
        [-ethers.parseEther("6.0"), ethers.parseEther("6.0")]
      );
    });
  });

  describe("Attack walletUnderflow", function () {
    it("let's try to attack a wallet with an obvious underflow vulnerability in the unchecked block.", async function () {
      const { walletUnderflow, attacker, user1, user2 } = await loadFixture(
        dep
      );

      const depositWalletUn = attacker.connect(user1).depositWalletUn();
      await expect(depositWalletUn).to.changeEtherBalances(
        [attacker, walletUnderflow],
        [-ethers.parseEther("1.0"), ethers.parseEther("1.0")]
      );

      const attackWalletUn = attacker.connect(user1).attackWalletUn();
      await expect(attackWalletUn).to.changeEtherBalances(
        [walletUnderflow, attacker],
        [-ethers.parseEther("6.0"), ethers.parseEther("6.0")]
      );

      const withdrawEthAttackerOwner = attacker.connect(user1).withdrawEth();
      await expect(withdrawEthAttackerOwner).to.changeEtherBalances(
        [attacker, user1],
        [-ethers.parseEther("6.0"), ethers.parseEther("6.0")]
      );
    });
  });
});
