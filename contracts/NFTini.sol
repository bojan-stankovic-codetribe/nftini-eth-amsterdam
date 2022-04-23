//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/utils/Counters.sol';
import './Album.sol';
import './Structures.sol';

contract NFTini {

    using Counters for Counters.Counter;

    mapping(uint => address) public albumIdToAlbumAddress;
    mapping(address => address) public albumOwners;
    Counters.Counter public albumId;

    function createAlbum(
        string memory _name,
        uint256 _packSize,
        uint256 _packPrice,
        bool _allowExpansion,
        Structures.Card[] memory _cards
    ) public {
        Album albumContract = new Album(_name, _packSize, _packPrice, _cards, _allowExpansion);
        albumIdToAlbumAddress[albumId.current()] = address(albumContract);
        albumOwners[address(albumContract)] = msg.sender;
        albumId.increment();
    }

    function addCard(uint _id, Structures.Card[] memory _cards) public {
        Album albumContract = getAlbumContract(_id);
        albumContract.addNewCards(_cards);
    }

    function completeAlbum(uint _id) public {
        Album albumContract = getAlbumContract(_id);
        require(msg.sender == albumOwners[address(albumContract)], "Only creator of album can complete it");
        albumContract.completeAlbum();
    }

    function getAlbumContract(uint256 _id) private view returns(Album) {
        return Album(albumIdToAlbumAddress[_id]);
    }

    function getPack(uint256 _id) public {
        Album albumContract = getAlbumContract(_id);
        albumContract.mint(msg.sender, "");
    }

    function getCardProbabilities(uint256 _id) public view returns(uint16[] memory) {
        Album albumContract = getAlbumContract(_id);
        return albumContract.getCardProbabilities();
    }

    function getPackPrice(uint256 _id) public view returns(uint) {
        Album albumContract = getAlbumContract(_id);
        return albumContract.packPrice();
    }

}