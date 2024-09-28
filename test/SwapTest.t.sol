// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/TokenSwap.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Mock ERC20 token for testing
contract MockERC20 is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}

contract TokenSwapTest is Test {
    TokenSwap tokenSwap;
    MockERC20 tokenA;
    MockERC20 tokenB;
    address swapper;

    function setUp() public {
        // Deploy mock tokens
        tokenA = new MockERC20("Token A", "TKA");
        tokenB = new MockERC20("Token B", "TKB");

        // Set initial reserves
        uint256 reserveA = 1000 ether;
        uint256 reserveB = 1000 ether;

        // Deploy TokenSwap contract
        tokenSwap = new TokenSwap(address(tokenA), address(tokenB), reserveA, reserveB);

        // Create a user who will perform the swap
        swapper = address(0x5678);

        // Mint tokens for the swapper
        tokenA.mint(swapper, 100 ether);
        tokenB.mint(swapper, 100 ether);

        // Approve TokenSwap contract to transfer tokens
        vm.prank(swapper);
        tokenA.approve(address(tokenSwap), 100 ether);
        tokenB.approve(address(tokenSwap), 100 ether);
    }
}
