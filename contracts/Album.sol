//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;

import '@openzeppelin/contracts/token/ERC1155/ERC1155.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import './Structures.sol';

// This is the main building block for smart contracts.
// This is the main building block for smart contracts.
contract Album is ERC1155, Ownable {

    string public name;
    Structures.Card[] public cards;
    bool public allowExpansion;

    constructor(
        string memory _uri,
        string memory _name,
        Structures.Card[] memory _cards
    ) ERC1155(_uri) {
        name = _name;
        for (uint256 index = 0; index < _cards.length; index++) {
            cards.push(_cards[index]);
        }
        allowExpansion = true;
    }

    function addNewCards(Structures.Card[] memory _cards) public onlyOwner {
        require(allowExpansion == true, "Expansion of album is not allowed");
        for(uint256 index = 0; index < _cards.length; index++) {
            cards.push(_cards[index]);
        }
    }

    function completeAlbum(address _creator) public onlyOwner {
        allowExpansion = false;
    }
}