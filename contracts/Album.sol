//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// This is the main building block for smart contracts.
// This is the main building block for smart contracts.
contract Album is ERC1155 {

    struct Card {
        string name;
    }

    string name;
    string[] cards;
    bool allowExpansion;

    constructor(string memory _uri, string memory _name, string[] memory _cards) ERC1155(_uri) {
        name = _name;
        cards = _cards;
        allowExpansion = true;
    }

    function addNewCard(string memory _card) public {
        cards.push(_card);
    }
}