// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "lib/openzeppelin-contracts/contracts/utils/Strings.sol";

/**
 * @title LXDAO 3rd Anniversary NFT
 * @dev ERC721 contract for LXDAO's 3rd Anniversary NFT with a 2-week minting period
 */
contract LXDAO3rdAnniversaryNFT is ERC721, Ownable {
    using Strings for uint256;

    // Minting period: end in June 16, 2025 00:00 UTC+8
    uint256 public constant MINT_END_TIME = 1750032000; // June 16, 2025, 00:00 UTC+8

    // Fixed metadata URI
    string public constant TOKEN_URI =
        "https://lxdao.io/metadata/LXDAO3ndAnniversaryNFT.json";

    // Total supply counter
    uint256 private _tokenIdCounter;

    // Mapping to track addresses that have already minted
    mapping(address => bool) private _hasMinted;

    constructor()
        ERC721("LXDAO 3rd Anniversary NFT", "LXDAO3")
        Ownable(msg.sender)
    {}

    /**
     * @dev Mint a new token
     * Requirements:
     * - Minting period must be active (May 29, 2025 to June 15, 2025)
     * - Each address can only mint once
     */
    function mint() external {
        require(block.timestamp <= MINT_END_TIME, "Minting period has ended");
        require(!_hasMinted[msg.sender], "Address has already minted");

        _hasMinted[msg.sender] = true;
        uint256 tokenId = _tokenIdCounter;
        _tokenIdCounter++;

        _safeMint(msg.sender, tokenId);
    }

    /**
     * @dev Returns the URI for a given token ID.
     * All tokens share the same metadata.
     */
    function tokenURI(uint256) public pure override returns (string memory) {
        return TOKEN_URI;
    }

    /**
     * @dev Returns the total number of tokens minted.
     */
    function totalSupply() public view returns (uint256) {
        return _tokenIdCounter;
    }

    /**
     * @dev Checks if an address has already minted.
     */
    function hasMinted(address user) public view returns (bool) {
        return _hasMinted[user];
    }

    /**
     * @dev Withdraw any ETH that might have been sent to the contract.
     * Only callable by the owner.
     */
    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
