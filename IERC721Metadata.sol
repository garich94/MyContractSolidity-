//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC721.sol";

interface IERC721Metadata is IERC721 {
    function name() external view returns(string memory); // название нашего токена
    
    function symbol() external view returns(string memory);// символ(короткое название токена)
    
    function tokenURI(uint tokenId) external view returns(string memory);// ссылка, на определённый токен 
}