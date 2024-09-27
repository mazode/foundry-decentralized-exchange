// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/LiquidityPool.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Mock ERC20 token for testing
contract MockERC20 is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}

contract LiquidityPoolTest is Test {
    LiquidityPool liquidityPool;
    MockERC20 tokenA;
    MockERC20 tokenB;
    address liquidityProvider;

    function setUp() public {
        // Deploy mock tokens
        tokenA = new MockERC20("Token A", "TKA");
        tokenB = new MockERC20("Token B", "TKB");

        // Deploy LiquidityPool contract
        liquidityPool = new LiquidityPool(address(tokenA), address(tokenB));

        // Create a user who will provide liquidity
        liquidityProvider = address(0x1234);

        // Mint tokens for the liquidity provider
        tokenA.mint(liquidityProvider, 1000 ether);
        tokenB.mint(liquidityProvider, 1000 ether);

        // Approve liquidity pool contract to transfer tokens
        vm.prank(liquidityProvider);
        tokenA.approve(address(liquidityPool), 1000 ether);
        tokenB.approve(address(liquidityPool), 1000 ether);
    }

    function testAddLiquidity() public {
        uint256 amountA = 100 ether;
        uint256 amountB = 100 ether;

        // Add liquidity to the Pool
        vm.prank(liquidityProvider);
        liquidityPool.addLiquidity(amountA, amountB);

        // Check reserves and liquidity
        assertEq(liquidityPool.reserveA(), amountA);
        assertEq(liquidityPool.reserveB(), amountB);
        assertEq(liquidityPool.liquidity(liquidityProvider), amountA + amountB);
    }
}
