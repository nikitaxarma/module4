// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
    mapping(string => uint256) public carPrices;
    mapping(address => mapping(string => uint256)) public redeemedItems; // Tracks the redeemed items for each player

    constructor(address initialOwner) ERC20("DegenToken", "DGN") Ownable(initialOwner) {
        // Initialize some items with their prices
        carPrices["bmw"] = 50;
        carPrices["mercedes"] = 200;
        carPrices["ALTO"] = 150;
    }
    // Minting new tokens (only owner)
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Redeeming tokens for car
    function redeem(string memory itemName) public {
        require(carPrices[itemName] > 0, "car does not exist");
        require(balanceOf(msg.sender) >= carPrices[itemName], "Insufficient balance");

        _burn(msg.sender, carPrices[itemName]);
        redeemedItems[msg.sender][itemName] += 1; // Record the redeemed item
        emit ItemRedeemed(msg.sender, itemName, carPrices[itemName]);
    }

    // Burning tokens
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    // Add new car (only owner)
    function addItem(string memory itemName, uint256 price) public onlyOwner {
        carPrices[itemName] = price;
    }

    // Check how many items a player has redeemed
    function getRedeemedItemCount(address player, string memory itemName) public view returns (uint256) {
        return redeemedItems[player][itemName];
    }

    // Event emitted when an item is redeemed
    event ItemRedeemed(address indexed player, string itemName, uint256 price);
}
