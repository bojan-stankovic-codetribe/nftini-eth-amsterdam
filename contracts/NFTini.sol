pragma solidity ^0.7.0;

import '@openzeppelin/contracts/utils/Counters.sol';
import './Album.sol';

contract NFTini {

    using Counters for Counters.Counter;

    struct Card {
        string name;
    }

    mapping(uint => address) public albumIdToAlbumAddress;
    Counters.Counter public albumId;
    Album public albumContract;

    function createAlbum(string memory _name, string[] memory _cards) public {
        string memory _uri = "https://abcoathup.github.io/SampleERC1155/api/token/{id}.json";
        albumContract = new Album(_uri, _name, _cards);
        albumIdToAlbumAddress[albumId.current()] = address(albumContract);
        albumId.increment();
    }

    function addCard(uint id, string memory _card) public {

    }
}