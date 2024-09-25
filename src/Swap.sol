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

    function swapAtoB(uint256 amountAIn) external {
        (uint256 reserveA, uint256 reserveB) = liquidityPool.getReserves();
        require(reserveA > 0 && reserveB > 0, "Invalid reserves");

        uint256 amountAInWithFee = amountAIn * 997 / 1000; // 0.3 %
        uint256 amountBOut = reserveB * amountAInWithFee / (reserveA + amountAInWithFee);

        require(amountBOut > 0, "Insufficient output");

        tokenA.transferFrom(msg.sender, address(liquidityPool), amountAIn);
        tokenB.transfer(msg.sender, amountBOut);

        liquidityPool.addLiquidity(amountAIn, amountBOut); // Update the liquidity
    }

    function swapBToA(uint256 amountBIn) external {
        (uint256 reserveA, uint256 reserveB) = liquidityPool.getReserves();
        require(reserveA > 0 && reserveB > 0, "Invalid reserves");

        uint256 amountBInWithFee = amountBIn * 997 / 1000; // 0.3% fee
        uint256 amountAOut = reserveA * amountBInWithFee / (reserveB + amountBInWithFee);

        require(amountAOut > 0, "Insufficient out");

        tokenB.transferFrom(msg.sender, address(liquidityPool), amountBIn);
        tokenA.transfer(msg.sender, amountAOut);

        liquidityPool.addLiquidity(amountAOut, amountBIn); // Update the liqduitiy
    }
}
