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

        // Approve liquidity pool contract to transfer tokens on behalf of liquidity provider
        vm.startPrank(liquidityProvider); // Start impersonating liquidity provider
        tokenA.approve(address(liquidityPool), 1000 ether);
        tokenB.approve(address(liquidityPool), 1000 ether);
        vm.stopPrank();
    }

    function testAddLiquidity() public {
        uint256 amountA = 100 ether;
        uint256 amountB = 100 ether;

        // Add liquidity to the pool
        vm.startPrank(liquidityProvider); // Impersonate liquidity provider
        liquidityPool.addLiquidity(amountA, amountB);
        vm.stopPrank();

        // Check token balances in the liquidity pool
        assertEq(tokenA.balanceOf(address(liquidityPool)), amountA, "Token A reserve mismatch");
        assertEq(tokenB.balanceOf(address(liquidityPool)), amountB, "Token B reserve mismatch");

        // Check reserves and liquidity amount
        assertEq(liquidityPool.reserveA(), amountA, "Reserve A mismatch");
        assertEq(liquidityPool.reserveB(), amountB, "Reserve B mismatch");
        assertEq(liquidityPool.liquidity(liquidityProvider), amountA + amountB, "Liquidity mismatch");
    }

    function testRemoveLiquidity() public {
        uint256 amountA = 100 ether;
        uint256 amountB = 100 ether;

        // Add liquidity first
        vm.startPrank(liquidityProvider);
        liquidityPool.addLiquidity(amountA, amountB);
        vm.stopPrank();

        uint256 liquidityAmount = liquidityPool.liquidity(liquidityProvider);

        // Remove liquidity
        vm.startPrank(liquidityProvider);
        liquidityPool.removeLiquidity(liquidityAmount);
        vm.stopPrank();

        // Check token balances after removal
        assertEq(tokenA.balanceOf(address(liquidityPool)), 0, "Token A reserve not cleared");
        assertEq(tokenB.balanceOf(address(liquidityPool)), 0, "Token B reserve not cleared");

        // Check reserves and liquidity after removal
        assertEq(liquidityPool.reserveA(), 0, "Reserve A not cleared");
        assertEq(liquidityPool.reserveB(), 0, "Reserve B not cleared");
        assertEq(liquidityPool.liquidity(liquidityProvider), 0, "Liquidity not cleared");
    }
}
