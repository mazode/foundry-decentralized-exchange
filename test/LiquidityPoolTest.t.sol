// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/LiquidityPool.sol";

contract LiquidityPoolTest is Test {
    LiquidityPool pool;
    IERC20 tokenA;
    IERC20 tokenB;\

    function setUp() public {
        tokenA = IERC20(deployMockERC20("TokenA", "TKA", 18));
        tokenB = IERC20(deployMockERC20("TokenB", "TKB", 18));
        pool = new LiquidityPool(address(tokenA), address(tokenB));
    }
    
}