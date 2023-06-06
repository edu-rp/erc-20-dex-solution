// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract QuilloToken is ERC20 {
    constructor() ERC20("QUILLO", "QUILLO") {
        uint256 killoPopulation = 8684000000; // Population in Andalucia as of Jan 2023.
        _mint(msg.sender, killoPopulation * 10**18);
    }
}