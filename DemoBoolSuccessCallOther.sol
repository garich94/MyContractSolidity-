// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Other {
    bytes public returneData;
    string public returnedName;

    function callGetName(address _demo) external {
        (bool result, bytes memory data) = _demo.call(
            abi.encodeWithSignature(
                "getName()"
            )
        );
        require(result, "failed");

        returneData = data;
        returnedName = string(abi.encodePacked(data));
    }

    function callSetData(address _demo, string calldata _newName, uint _newAge) external {
        (bool result, ) = _demo.call(
            abi.encodeWithSignature(
                "setData(string,uint256)",
                _newName,
                _newAge
            )
        );

        require(result, "failed");
    }

    function callPay(address _demo) external payable {
        (bool result,) = _demo.call{value: msg.value}(
            abi.encodeWithSignature(
                "pay(address)",
                msg.sender
            )
        );

        require(result, "failed");
    }
}