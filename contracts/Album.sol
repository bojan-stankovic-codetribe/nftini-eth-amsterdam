//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC1155/ERC1155.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import './Structures.sol';


contract Album is ERC1155, Ownable {

    string public name;
    Structures.Card[] public cards;
    bool public allowExpansion;

    constructor(
        string memory _uri,
        string memory _name,
        Structures.Card[] memory _cards,
        bool _allowExpansion
    ) ERC1155(_uri) {
        name = _name;
        for (uint256 index = 0; index < _cards.length; index++) {
            cards.push(_cards[index]);
        }
        allowExpansion = _allowExpansion;
    }

    function addNewCards(Structures.Card[] memory _cards) public onlyOwner {
        require(allowExpansion, "Expansion of album is not allowed");
        for(uint256 index = 0; index < _cards.length; index++) {
            cards.push(_cards[index]);
        }
    }

    function completeAlbum() public onlyOwner {
        require(!allowExpansion, "Album expansion is already disabled.");
        allowExpansion = false;
    }
}