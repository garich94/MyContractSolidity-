// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

library NumbersChecker {
    function even(uint _myInt) internal pure returns(bool) {
        return _myInt % 2 == 0;
    }
}

contract Demo {
    using NumbersChecker for uint;
    uint myInt = 4;

    function isEven() public view returns(bool) {
        return myInt.even();
        
        //return NumbersChecker.even(myInt);
    }
}