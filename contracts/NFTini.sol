//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/utils/Counters.sol';
import './Album.sol';
import './Structures.sol';

contract NFTini {

    using Counters for Counters.Counter;

    mapping(uint => address) public albumIdToAlbumAddress;
    mapping(address => address) public albumOwners;
    Counters.Counter public albumId;

    event AlbumCreated(uint256 indexed id, string name);

    function createAlbum(string memory _name,
                        Structures.Card[] memory _cards,
                        bool _allowExpansion) public {
        string memory _uri = "https://abcoathup.github.io/SampleERC1155/api/token/{id}.json";
        Album albumContract = new Album(_uri, _name, _cards, _allowExpansion);
        albumIdToAlbumAddress[albumId.current()] = address(albumContract);
        albumOwners[address(albumContract)] = msg.sender;
        emit AlbumCreated(albumId.current(), _name);
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

}