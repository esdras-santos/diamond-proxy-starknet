pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Dungeon is ERC721{
    uint256 tokenCounter;
    mapping (uint256=>string) public tokenUri;
    constructor () public ERC721("DungeonItems", "DI"){
        tokenCounter = 0;
    }

    function createCollectible(string memory tokenURI) external returns (uint256) {
        uint256 newItemId = tokenCounter;
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);
        tokenCounter = tokenCounter + 1;
        return newItemId;
    }

    function _setTokenURI(uint256 _tokenId, string memory _tokenURI) private{
        require(ownerOf(_tokenId) == msg.sender);
        tokenUri[_tokenId] = _tokenURI;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory){
        return tokenUri[tokenId];
    } 
}