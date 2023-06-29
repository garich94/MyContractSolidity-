// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IDemo {
     function pay() external payable; 
}

contract Other {
    address public sender;

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function callPay(address _demo) external payable {
        (bool result,) = _demo.delegatecall(
            abi.encodeWithSelector(
                IDemo.pay.selector
            )
        );

        require(result, "failed");
    }
}