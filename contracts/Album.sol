//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC1155/ERC1155.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import '@openzeppelin/contracts/utils/math/SafeMath.sol';

import './Structures.sol';

// This is the main building block for smart contracts.
contract Album is ERC1155, Ownable, ReentrancyGuard {

    using SafeMath for uint256;

    string public name;
    uint256 packSize;
    uint256 public packPrice;
    bool public allowExpansion;
    uint256 NUM_CLASSES;
    uint16[] public cardProbabilities;
    uint256 constant INVERSE_BASIS_POINT = 10000;
    mapping(uint => string) tokenURI;

    constructor(
        string memory _name,
        string[] memory _cards
    ) ERC1155("https://ipfs.infura.io/ipfs/{id}") {
        name = _name;
        for (uint256 index = 0; index < _cards.length; index++) {
            tokenURI[index] = _cards[index];
            cardProbabilities.push(10);
        }
    }

//    function addNewCards(string[] memory _cards) public onlyOwner {
//        require(allowExpansion, "Expansion of album is not allowed");
//        for(uint256 index = 0; index < _cards.length; index++) {
//            cards.push(_cards[index]);
//        }
//    }

    function completeAlbum() public onlyOwner {
        require(!allowExpansion, "Album expansion is already disabled.");
        allowExpansion = false;
    }

    function mint(
        address _toAddress,
        bytes memory /* _data */
    ) external nonReentrant {
        require(allowExpansion == false, "Album is not complete yet");
        // Iterate over the quantity of boxes specified
        for (uint256 i = 0; i < 3; i++) {
            // Iterate over the box's set quantity
            uint256 cardToSend = i;
            _mint(_toAddress, cardToSend, 1, "");
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
        uint number = block.timestamp;
        return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty, msg.sender))) % number;
    }

    function getCardProbabilities() public view returns (uint16[] memory) {
        return cardProbabilities;
    }

    function uri(uint256 _id) public view virtual override returns (string memory) {
        return tokenURI[_id];
    }

}