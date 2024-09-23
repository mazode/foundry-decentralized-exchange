// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./LiquidityPool.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Swap {
    LiquidityPool public liquidityPool;
    IERC20 public tokenA;
    IERC20 public tokenB;

    constructor(address _liquidityPool) {
        liquidityPool = LiquidityPool(_liquidityPool);
        tokenA = IERC20(liquidityPool.tokenA());
        tokenB = IERC20(liquidityPool.tokenB());
    }
}
