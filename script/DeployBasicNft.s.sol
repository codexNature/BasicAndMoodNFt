//SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {BasicNft} from "../src/BasicNFT.sol";

contract DeployBasicNft is Script {
    function run() external returns (BasicNft) {
      vm.startBroadcast();
      BasicNft basicNft = new BasicNft();
      vm.stopBroadcast();
      return basicNft;
    }
}
