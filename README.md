# ETH-AVAX-Intermediate-Project4 Building on Avalanche

This repository contains the MyERC20Token smart contract, which implements an ERC20 token with additional functionalities for minting, burning, transferring tokens, and a store to trade and redeem products.

## Description

This Solidity project involves creating an ERC20 token for Degen Gaming on the Avalanche network. The contract includes functionalities for minting, transferring, redeeming, and burning tokens. It also features a virtual store where players can trade tokens for in-game items. Only the owner can mint tokens, while any player can transfer, redeem, or burn their tokens, and check their balance at any time.

## Prerequisites

- [MetaMask](https://metamask.io/) installed in your browser
- [Remix IDE](https://remix.ethereum.org/) for compiling and deploying the contract

## Getting Started

### Executing program

1. To run this program, we can use Remix at https://remix.ethereum.org/.
2. Create a new file by clicking on the "+" icon in the left-hand sidebar.
3. Save the file with a .sol extension 

```javascript
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

    mapping(address => mapping(uint256 => uint256)) public redeemedItems; // Maps address to product index and quantity

    // Minting tokens
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
    function loadShopItems() external onlyOwner {
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

        require(redeemedItems[msg.sender][proIndex] > 0, "You do not have this product to trade");

        // Update redeemed items
        redeemedItems[msg.sender][proIndex] -= 1;
        redeemedItems[recipient][proIndex] += 1;

        // Transfer tokens equivalent to the product price
        uint256 curTokens = balanceOf(msg.sender);
        require(curTokens >= proPrice, "Insufficient token amount to trade product");
        _transfer(msg.sender, recipient, proPrice);
    }

    // Redeeming tokens allows to redeem product in the shop
    function redeemTokens(uint256 proIndex) external {
        require(proIndex < store.length, "Product does not exist in the store");
        Product memory proSelected = store[proIndex];
        uint256 proPrice = proSelected.price;

        uint256 currTokens = balanceOf(msg.sender);
        require(currTokens >= proPrice, "Insufficient token amount to redeem product");
        _burn(msg.sender, proPrice);

        // Update redeemed items
        redeemedItems[msg.sender][proIndex] += 1;
    }

    // Checking token balance
    function getBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    // Checking redeemed items
    function getRedeemedItems(address account, uint256 proIndex) external view returns (uint256) {
        return redeemedItems[account][proIndex];
    }
}

```

## Connecting MetaMask with Avalanche Fuji Network

1. Open MetaMask and click on the network dropdown at the top.
2. Select "Add Network" and fill in the following details:
    - **Network Name:** Avalanche Fuji C-Chain
    - **New RPC URL:** https://api.avax-test.network/ext/bc/C/rpc
    - **ChainID:** 43113
    - **Symbol:** AVAX
3. Save and switch to the new network.

## Compiling the Code

1. Open [Remix IDE](https://remix.ethereum.org/).
2. Go to the 'Solidity Compiler' tab on the left.
3. Set the Compiler to version 0.8.26 or a compatible version.
4. Click Compile.

## Deploying the Contract

1. Go to the 'Deploy & Run Transactions' tab on the left in Remix IDE.
2. Ensure the Environment is set to "Injected Web3" to connect with your MetaMask wallet.
3. Enter the initial owner's address in the "initialOwner" field.
4. Click Deploy.

## Interacting with the Contract

Once deployed, you can interact with the contract using the following functions:

- **mint(address to, uint256 amount)**: Mint new tokens to a specified address (only owner).
- **burnTokens(uint256 amount)**: Burn tokens from your balance.
- **transferTokens(address to, uint256 amount)**: Transfer tokens to another address.
- **LoadShopItems()**: Load predefined shop items into the store (only owner).
- **tradeProduct(address recipient, uint256 proIndex)**: Trade a product with another player.
- **redeemTokens(uint256 proIndex)**: Redeem tokens for a product in the shop.
- **getBalance()**: Check your token balance.

## Verifying Contract on Snowtrace

1. Go to [Snowtrace Testnet](https://testnet.snowtrace.io/).
2. Search for your contract address.
3. Complete the verification.

## Authors

Nikhil Maurya


## License

This project is licensed under the MIT License - see the LICENSE.md file for details
