//SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";  // installed DevopsTools from GH with     forge install ChainAccelOrg/foundry-devops --no-commit
import {BasicNft} from "../src/BasicNFT.sol";

contract MintBasicNft is Script {
      string public constant StBernard = 
      "ipfs://bafybeiafb4h2mmnckn636a7mlpu634fticrpqkj65bmn67yxirjo7pdtcm";
      function run() external { //this function is gonna mint our NFT.
          address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "BasicNft", 
            block.chainid
            );
            mintNftOnContract(mostRecentlyDeployed);
      }

      function mintNftOnContract(address contractAddress) public {
          vm.startBroadcast();
          BasicNft(contractAddress).mintNft(StBernard);
          vm.stopBroadcast();
      }

}