//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC1155/ERC1155.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import '@openzeppelin/contracts/utils/math/SafeMath.sol';

import './Structures.sol';

// This is the main building block for smart contracts.
// This is the main building block for smart contracts.
contract Album is ERC1155, Ownable, ReentrancyGuard {

    using SafeMath for uint256;

    string public name;
    uint256 packSize;
    uint256 packPrice;
    Structures.Card[] public cards;
    bool public allowExpansion;
    uint256 NUM_CLASSES;
    uint16[] cardProbabilities;
    uint256 constant INVERSE_BASIS_POINT = 10000;

    constructor(
        string memory _uri,
        string memory _name,
        uint256 _packSize,
        uint256 _packPrice,
        Structures.Card[] memory _cards
    ) ERC1155(_uri) {
        name = _name;
        packSize = _packSize;
        packPrice = _packPrice;
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

    function completeAlbum() public onlyOwner {
        allowExpansion = false;
        NUM_CLASSES = cards.length;
        cardProbabilities = new uint16[](NUM_CLASSES);
    }

    function mint(
        address _toAddress,
        uint256 _amount,
        bytes memory /* _data */
    ) internal nonReentrant {
        require(allowExpansion == false, "Album is not complete yet");
        // Iterate over the quantity of boxes specified
        for (uint256 i = 0; i < _amount; i++) {
            // Iterate over the box's set quantity
            uint256 quantitySent = 0;

            // Process non-guaranteed ids
            while (quantitySent < packSize) {
                uint256 cardToSend = _pickRandomCard(cardProbabilities);
                _mint(_toAddress, cardToSend, 1, "");
                quantitySent += 1;
            }
        }
    }

    function _pickRandomCard(
        uint16[] memory _cardProbabilities
    ) internal view returns(uint256) {
        uint16 value = uint16(_random().mod(INVERSE_BASIS_POINT));
        // Start at top class (length - 1)
        // skip common (0), we default to it
        for (uint256 i = _cardProbabilities.length - 1; i > 0; i--) {
            uint16 probability = _cardProbabilities[i];
            if (value < probability) {
                return i;
            } else {
                value = value - probability;
            }
        }
        return 0;
    }

    function _random() internal view returns (uint256) {
        uint256 randomNumber = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), msg.sender)));
        return randomNumber;
    }
}