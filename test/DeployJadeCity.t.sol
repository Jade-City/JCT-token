// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "forge-std/Test.sol";
import "../script/DeployJadeCity.s.sol";

contract DeployJadeCityTest is Test {
    DeployJadeCity deployScript;
    JadeCity token;
    address receiver;

    function setUp() public {
        receiver = vm.envAddress("RECEIVER_ADDRESS"); // Use default if env not set
        deployScript = new DeployJadeCity();
    }

    function testDeployment() public {
        address deployedAddress = deployScript.run(); // Get deployed contract address

        assertEq(receiver, address(0xb34120a60141e3e3A65d60cA7428bf4C989bd9A5), "Address mismatch");

        token = JadeCity(deployedAddress); // Cast to contract type

        assertEq(token.totalSupply(), 1_000_000_000 * 10 ** token.decimals(), "Total supply mismatch after deployment");
        assertEq(token.balanceOf(receiver), 1_000_000_000 * 10 ** token.decimals(), "Receiver balance mismatch");
    }
}
