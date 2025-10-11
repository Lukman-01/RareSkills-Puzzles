// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IUniswapV2Pair.sol";
import "./interfaces/IERC20.sol";

contract SimpleSwap {
    /**
     *  PERFORM A SIMPLE SWAP WITHOUT ROUTER EXERCISE
     *
     *  The contract has an initial balance of 1 WETH.
     *  The challenge is to swap any amount of WETH for USDC token using the `swap` function
     *  from USDC/WETH pool.
     *
     */
    function performSwap(address pool, address weth, address usdc) public {
        /**
         *     swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data);
         *
         *     amount0Out: the amount of USDC to receive from swap.
         *     amount1Out: the amount of WETH to receive from swap.
         *     to: recipient address to receive the USDC tokens.
         *     data: leave it empty.
         */

        IUniswapV2Pair pair = IUniswapV2Pair(pool);
        
        // Get WETH balance of this contract
        uint256 wethBalance = IERC20(weth).balanceOf(address(this));
        
        // Transfer WETH to the pool
        IERC20(weth).transfer(pool, wethBalance);
        
        // Get reserves to calculate output amount
        (uint112 reserve0, uint112 reserve1,) = pair.getReserves();
        
        // Determine which token is USDC and which is WETH
        address token0 = pair.token0();
        
        uint256 amountOut;
        if (token0 == usdc) {
            // USDC is token0, WETH is token1
            // Calculate USDC output using x*y=k formula with 0.3% fee
            amountOut = (wethBalance * 997 * reserve0) / ((reserve1 * 1000) + (wethBalance * 997));
            pair.swap(amountOut, 0, address(this), "");
        } else {
            // WETH is token0, USDC is token1
            amountOut = (wethBalance * 997 * reserve1) / ((reserve0 * 1000) + (wethBalance * 997));
            pair.swap(0, amountOut, address(this), "");
        }
    }
}
