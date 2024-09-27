// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenSwap {
    IERC20 public tokenA;
    IERC20 public tokenB;

    uint256 public reserveA;
    uint256 public reserveB;

    event Swap(address indexed swapper, uint256 amountIn, uint256 amountOut, address tokenIn, address tokenOut);

    constructor(address _tokenA, address _tokenB, uint256 _reserveA, uint256 _reserveB) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
        reserveA = _reserveA;
        reserveB = _reserveB;
    }

    // Swap between tokens A and B
    function swap(address tokenIn, uint256 amountIn) external returns (uint256 amountOut) {
        require(amountIn > 0, "Amount must be greater than zero");
        require(tokenIn == address(tokenA) || tokenIn == address(tokenB), "Invalid token");

        bool isTokenA = (tokenIn == address(tokenA));

        // Calculate amountOut using a simple x * y = k formula
        if (isTokenA) {
            amountOut = getAmountOut(amountIn, reserveA, reserveB);
            tokenA.transferFrom(msg.sender, address(this), amountIn);
            tokenB.transfer(msg.sender, amountOut);
            reserveA += amountIn;
            reserveB -= amountOut;
        } else {
            amountOut = getAmountOut(amountIn, reserveB, reserveA);
            tokenB.transferFrom(msg.sender, address(this), amountIn);
            tokenA.transfer(msg.sender, amountOut);
            reserveB += amountIn;
            reserveA -= amountOut;
        }

        emit Swap(msg.sender, amountIn, amountOut, tokenIn, isTokenA ? address(tokenB) : address(tokenA));
    }

    // Calculate the output amount based on the reserves
    function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) public pure returns (uint256) {
        require(amountIn > 0, "Amount must be greater than zero");
        require(reserveIn > 0 && reserveOut > 0, "Reserves must be greater than zero");

        // Constant product formula: x * y = k
        uint256 amountInWithFee = amountIn * 997; // 0.3% fee
        uint256 numerator = amountInWithFee * reserveOut;
        uint256 denominator = (reserveIn * 1000) + amountInWithFee;
        return numerator / denominator;
    }
}
