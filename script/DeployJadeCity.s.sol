// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "forge-std/Script.sol";
import "../src/JadeCity.sol";

contract DeployJadeCity is Script {
    function run() external returns (address) {
        address receiver = vm.envAddress("RECEIVER_ADDRESS");
        require(receiver != address(0), "Receiver address must be set");

        vm.startBroadcast();
        JadeCity token = new JadeCity(receiver);
        vm.stopBroadcast();

        return address(token);
    }
}
