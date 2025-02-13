// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract JadeCity is ERC20, ERC20Burnable, ERC20Permit {
    constructor(address _receiver) ERC20("Jade City", "JCT") ERC20Permit("Jade City") {
        require(_receiver != address(0), "Receiver cannot be zero");
        _mint(_receiver, 1_000_000_000 * 10 ** decimals());
    }
}
