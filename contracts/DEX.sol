pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Whoever deploy this contract is the person who wants to sell their tokens.
// They can sell any kind of ER20 token that they want. In our case it's going to be EduCoin token.
// They just have to send the address of the token contract.
// Only the owner of the specific contract to be sold--in this case, me--can sell their token for the price they believe appropriate.
contract DEX {
    IERC20 public associatedToken; // EduToken

    uint256 price; // Price to be sold for.
    address owner; // Owner or deployer of this contract

    constructor(IERC20 _token, uint256 _price) {
        associatedToken = _token;
        owner = msg.sender;
        price = _price;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "you are not the owner");
        _;
    }

    function sell() external onlyOwner {
        uint256 allowance = associatedToken.allowance(
            msg.sender,
            address(this)
        ); // Checks if this contract has allowance to sell EduCoin tokens from owner.
        require(
            allowance > 0,
            "you must allow this contract access to at least one token"
        );
        bool sent = associatedToken.transferFrom(
            msg.sender,
            address(this),
            allowance
        );
        require(sent, "failed to send");
    }

    function withdrawTokens() external onlyOwner {
        uint256 balance = associatedToken.balanceOf(address(this));
        associatedToken.transfer(msg.sender, balance);
    }

    function withdrawFunds() external onlyOwner {
        (bool sent, ) = payable(msg.sender).call{value: address(this).balance}(
            ""
        );
        require(sent);
    }

    function getPrice(uint256 numTokens) public view returns (uint256) {
        return numTokens * price;
    }

    function buy(uint256 numTokens) external payable {
        require(numTokens <= getTokenBalance(), "not enough tokens");
        uint256 priceForTokens = getPrice(numTokens);
        require(msg.value == priceForTokens, "invalid value sent");

        associatedToken.transfer(msg.sender, numTokens);
    }

    function getTokenBalance() public view returns (uint256) {
        return associatedToken.balanceOf(address(this));
    }
}
