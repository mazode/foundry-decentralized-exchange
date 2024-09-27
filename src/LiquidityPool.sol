// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LiquidityPool {
    IERC20 public tokenA;
    IERC20 public tokenB;

    uint256 public reserveA;
    uint256 public reserveB;

    // Mapping to track liquidity provided by each address
    mapping(address => uint256) public liquidity;

    // Events for liquidity management
    event LiquidityAdded(address indexed provider, uint256 amountA, uint256 amountB);
    event LiquidityRemoved(address indexed provider, uint256 amountA, uint256 amountB);

    constructor(address _tokenA, address _tokenB) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    // Add liquidity to the pool
    function addLiquidity(uint256 amountA, uint256 amountB) external {
        require(amountA > 0 && amountB > 0, "Amount must be greater than zero");

        // Transfer tokens from sender to contract
        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transferFrom(msg.sender, address(this), amountB);

        // Update reserves
        reserveA += amountA;
        reserveB += amountB;

        // Track liquidity added by the sender
        liquidity[msg.sender] += amountA + amountB;

        emit LiquidityAdded(msg.sender, amountA, amountB);
    }

    // Remove liquidity from the pool
    function removeLiquidity(uint256 liquidityAmount) external {
        require(liquidity[msg.sender] >= liquidityAmount, "Insufficient liquidity");

        // Calculate token amounts to return based on reserves
        uint256 amountA = (liquidityAmount * reserveA) / (reserveA + reserveB);
        uint256 amountB = (liquidityAmount * reserveB) / (reserveA + reserveB);

        // Reduce liquidity
        liquidity[msg.sender] -= liquidityAmount;

        // Update reserves
        reserveA -= amountA;
        reserveB -= amountB;

        // Transfer tokens back to the user
        tokenA.transfer(msg.sender, amountA);
        tokenB.transfer(msg.sender, amountB);

        emit LiquidityRemoved(msg.sender, amountA, amountB);
    }
}
