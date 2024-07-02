// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {

    event Redeemed(address indexed account, uint256 amount, string item);

    constructor() ERC20("Degen", "DGN") {}

    // Minting new tokens: Only the owner can mint tokens
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Burning tokens: Anyone can burn their own tokens
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    // Redeeming tokens for items in the in-game store
    function redeem(uint256 amount, string memory item) public {
        require(balanceOf(msg.sender) >= amount, "Insufficient token balance to redeem");
        _burn(msg.sender, amount);
        emit Redeemed(msg.sender, amount, item);
    }

    // Note: Transferring tokens and checking balance are already handled by ERC20 contract
}
