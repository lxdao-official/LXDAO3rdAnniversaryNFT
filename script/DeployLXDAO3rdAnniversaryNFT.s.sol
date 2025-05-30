// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {LXDAO3rdAnniversaryNFT} from "../src/LXDAO3rdAnniversaryNFT.sol";

contract DeployLXDAO3rdAnniversaryNFT is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);
        
        LXDAO3rdAnniversaryNFT nft = new LXDAO3rdAnniversaryNFT();
        
        vm.stopBroadcast();
        
        console.log("LXDAO3rdAnniversaryNFT deployed at:", address(nft));
    }
}
