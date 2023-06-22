// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/Mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {

    struct NetworkConfig {
        address ETHUSDPriceFeedAddress;
    }

    NetworkConfig public activeNetworkConfig;

    uint8 constant DECIMALS = 8;
    int256 constant INITIAL_PRICE = 2000e8;

    constructor() {
        if(block.chainid == 11155111){
            activeNetworkConfig = getSepoliaNetworkConfig();
        }else if(block.chainid == 1) {
            activeNetworkConfig = getMainNetNetworkConfig();
        }
        else {
            activeNetworkConfig = getOrCreateAnvilNetworkConfig();
        }
    }

    function getSepoliaNetworkConfig() public pure returns (NetworkConfig memory){
         NetworkConfig memory sepoliaNetworkConfig = NetworkConfig({ETHUSDPriceFeedAddress: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
         return sepoliaNetworkConfig;
    }

    function getMainNetNetworkConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory mainNetNetworkConfig = NetworkConfig({ETHUSDPriceFeedAddress: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        return mainNetNetworkConfig;
    }

    function getOrCreateAnvilNetworkConfig() public  returns (NetworkConfig memory){
        if(activeNetworkConfig.ETHUSDPriceFeedAddress != address(0)){
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();
        NetworkConfig memory anvilNetworkConfig = NetworkConfig({ETHUSDPriceFeedAddress: address(mockPriceFeed) });
        return anvilNetworkConfig;
    }
}