pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    // Mint the initial supply of tokes to whoever deploy this contract. That means that, the address that deploys this contract holds the entire supply
    constructor(uint256 initialSupply) ERC20("EduCoin", "EDU") {
        // Name and simbol of the toekn coin.
        _mint(msg.sender, initialSupply);
    }
}
