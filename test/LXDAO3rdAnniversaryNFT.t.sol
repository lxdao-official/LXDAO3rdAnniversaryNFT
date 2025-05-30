// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {LXDAO3rdAnniversaryNFT} from "../src/LXDAO3rdAnniversaryNFT.sol";

contract LXDAO3rdAnniversaryNFTTest is Test {
    LXDAO3rdAnniversaryNFT public nft;
    address public user1 = address(0x1);
    address public user2 = address(0x2);

    function setUp() public {
        nft = new LXDAO3rdAnniversaryNFT();
    }

    function testMintingPeriod() public {
        // Test minting before end time
        vm.warp(nft.MINT_END_TIME() - 1 days);
        vm.prank(user1);
        nft.mint();
        assertEq(nft.ownerOf(0), user1);
        assertEq(nft.totalSupply(), 1);
        assertEq(nft.hasMinted(user1), true);

        // Test after minting period
        vm.warp(nft.MINT_END_TIME() + 1);
        vm.prank(user2);
        vm.expectRevert("Minting period has ended");
        nft.mint();
    }

    function testOneMintPerAddress() public {
        // Set time before end time
        vm.warp(nft.MINT_END_TIME() - 1 days);
        
        // First mint should succeed
        vm.prank(user1);
        nft.mint();
        assertEq(nft.ownerOf(0), user1);
        
        // Second mint should fail
        vm.prank(user1);
        vm.expectRevert("Address has already minted");
        nft.mint();
    }

    function testTokenURI() public {
        vm.warp(nft.MINT_END_TIME() - 1 days);
        vm.prank(user1);
        nft.mint();
        
        string memory uri = nft.tokenURI(0);
        assertEq(uri, "https://lxdao.io/metadata/LXDAO3ndAnniversaryNFT.json");
    }

    function testMultipleAddressesMint() public {
        vm.warp(nft.MINT_END_TIME() - 1 days);
        
        // User 1 mints
        vm.prank(user1);
        nft.mint();
        assertEq(nft.ownerOf(0), user1);
        
        // User 2 mints
        vm.prank(user2);
        nft.mint();
        assertEq(nft.ownerOf(1), user2);
        
        // Check total supply
        assertEq(nft.totalSupply(), 2);
    }
}
