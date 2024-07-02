// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract MyERC20Token is ERC20, Ownable, ERC20Burnable {

    constructor(address initialOwner) ERC20("Degen Gaming", "DGN") Ownable(initialOwner) {}

    struct Product {
        string name;
        uint price;
    }
    Product[] public store;

    //Minting tokens
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Burning tokens
    function burnTokens(uint256 amount) external {
        uint256 currTokens = balanceOf(msg.sender);
        require(currTokens >= amount, "Insufficient token amount to burn");
        burn(amount);
    }

    // Transferring tokens
    function transferTokens(address to, uint256 amount) external {
        uint256 curTokens = balanceOf(msg.sender);
        require(curTokens >= amount, "Insufficient funds to transfer");
        _transfer(msg.sender, to, amount);
    }

    // Adding items to the shop for redeeming
    function LoadShopItems() external onlyOwner {
        store.push(Product("Exclusive Skin", 1));
        store.push(Product("Booster Pack", 1));
        store.push(Product("Special Weapon", 5));
        store.push(Product("Energy Drink", 20));
        store.push(Product("Game Upgrade", 10));
    }

    // Trading items between players
    function tradeProduct(address recipient, uint256 proIndex) external {
        require(proIndex < store.length, "Product does not exist in the store");
        Product memory proSelected = store[proIndex];
        uint256 proPrice = proSelected.price;

        uint256 curTokens = balanceOf(msg.sender);
        require(curTokens >= proPrice, "Insufficient token amount to trade product");
        _burn(msg.sender, proPrice);
        _mint(recipient, proPrice);
    }

    // Redeeming tokens allows to redeem product in the shop
    function redeemTokens(uint256 proIndex) external {
        require(proIndex < store.length, "Product does not exist in the store");
        Product memory proSelected = store[proIndex];
        uint256 proPrice = proSelected.price;

        uint256 currTokens = balanceOf(msg.sender);
        require(currTokens >= proPrice, "Insufficient token amount to redeem product");
        _burn(msg.sender, proPrice);
    }

    // Checking token balance
    function getBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }
}
