// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC20.sol";
import "./IERC4626.sol";
import "./utils/Math.sol";

abstract contract ERC4626 is ERC20, IERC4626 {
    using Math for uint256;

    ERC20 private immutable _asset; //привязка к asset который можно вкладывать
    uint8 private immutable _underlyingDecimals; //кол-во знаков после запятой в asset 

    constructor(ERC20 asset_) {
        (bool success, uint8 assetDecimals) = _tryGetAssetDecimals(asset_);
        _underlyingDecimals = success ? assetDecimals : 18;
        _asset = asset_; 
    }

    function _tryGetAssetDecimals(ERC20 asset_) private view returns(bool, uint8) {
        (bool success, bytes memory encodeDecimals) = address(asset_).staticall(
            abi.encodeWithSelector(ERC20Metadata.decimals.selector)
        )
    }
}