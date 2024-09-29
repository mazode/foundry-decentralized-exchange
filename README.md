# Token Swap and Liquidity Pool

## Overview

This project demonstrates a simple decentralized token swap and liquidity pool system implemented in Solidity. It allows users to swap tokens based on the reserves in the pool using an automated market-making (AMM) algorithm. Additionally, the project includes functionality for users to add and remove liquidity to the pool.

## Features

- **Token Swap:** Allows users to swap between two ERC20 tokens, using the reserves in the pool to determine the exchange rate.
- **Liquidity Management:** Users can add or remove liquidity from the pool, adjusting the token reserves.
- **Automated Market Making (AMM):** The contract adjusts the price dynamically based on the available token reserves.

## Project Structure

### Contracts

- **LiquidityPool.sol**: Handles adding/removing liquidity to the pool and tracks token reserves.
- **Swap.sol**: Facilitates token swaps based on the liquidity pool reserves using AMM principles.
- **MockERC20.sol**: A mock ERC20 token for testing purposes.

### Tests

The project uses [Foundry](https://book.getfoundry.sh/) for testing the smart contracts. Test files are included to verify the functionality of token swaps and liquidity management:

- `LiquidityPoolTest.t.sol`: Contains unit tests for adding/removing liquidity.
- `SwapTest.t.sol`: Contains unit tests for swapping tokens using the liquidity pool.
