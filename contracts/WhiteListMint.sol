// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@opengsn/contracts/src/BaseRelayRecipient.sol";

/**
 * @title WLERC721
 * @dev Create a sample ERC721 standard token with WL functionality
 */

contract WhitelistMint is ERC721, Ownable, BaseRelayRecipient {
    constructor(
        string memory tokenName,
        string memory tokenSymbol,
        address[] memory whitelistArray,
        string memory _URI,
        address forwarder
    ) ERC721(tokenName, tokenSymbol) {
        for (uint256 i = 0; i < whitelistArray.length; i++) {
            whitelistMap[whitelistArray[i]] = true;
        }
        baseURI = _URI;
        _setTrustedForwarder(forwarder);
    }

    string public override versionRecipient = "1.0.0";

    mapping(address => bool) public whitelistMap;
    uint256 public maxSupply = 3000;
    uint256 public tokenId;

    string private baseURI;

    function mint() public payable {
        require(whitelistMap[_msgSender()], "Not in Whitelist");
        require(tokenId < maxSupply, "Collection Sold out!");
        require(balanceOf(_msgSender()) == 0, "Already Minted");
        _safeMint(_msgSender(), tokenId);
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

    function _msgSender()
        internal
        view
        override(Context, BaseRelayRecipient)
        returns (address sender)
    {
        return BaseRelayRecipient._msgSender();
    }

    function _msgData()
        internal
        view
        override(Context, BaseRelayRecipient)
        returns (bytes memory)
    {
        return BaseRelayRecipient._msgData();
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(_tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory currentBaseURI = _baseURI();
        return
            bytes(currentBaseURI).length > 0
                ? string(abi.encodePacked(currentBaseURI, _tokenId, ".json"))
                : "";
    }

    // Only Owner
    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }
}
