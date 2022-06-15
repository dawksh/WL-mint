// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


/**
 * @title WLERC721
 * @dev Create a sample ERC721 standard token with WL functionality
 */

contract WhitelistMint is ERC721, Ownable {

    constructor(string memory tokenName, string memory tokenSymbol, address[] memory whitelistArray, string memory _URI) ERC721(tokenName, tokenSymbol) {
        for(uint i = 0; i<= whitelistArray.length; i++) {
            whitelistMap[whitelistArray[i]] = true;
        }
        baseURI = _URI;
    }

    mapping(address => bool) public whitelistMap;
    uint256 public maxSupply = 3000;
    uint256 public tokenId;

    string private baseURI;

    function mint() public payable {
        require(whitelistMap[msg.sender], "Not in Whitelist");
        require(tokenId < maxSupply, "Collection Sold out!");
        require(balanceOf(msg.sender) == 0, "Already Minted");
        payable(owner()).transfer(msg.value);
        _safeMint(msg.sender, tokenId);
        tokenId++;
    }

    // Internal Functions

    function _beforeTokenTransfer(
    address from,
    address to,
    uint256 _tokenId
    ) internal virtual override(ERC721) {
        super._beforeTokenTransfer(from, to, _tokenId);

        uint256 amount = msg.value;
        payable(to).transfer((95 * amount) / 100);
        payable(owner()).transfer((5 * amount) / 100);
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    // Only Owner
    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

}