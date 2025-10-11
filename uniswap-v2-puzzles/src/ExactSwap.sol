// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IUniswapV2Pair.sol";
import "./interfaces/IERC20.sol";

contract ExactSwap {
    /**
     *  PERFORM AN SIMPLE SWAP WITHOUT ROUTER EXERCISE
     *
     *  The contract has an initial balance of 1 WETH.
     *  The challenge is to swap an exact amount of WETH for 1337 USDC token using the `swap` function
     *  from USDC/WETH pool.
     *
     */
    function performExactSwap(address pool, address weth, address usdc) public {
        /**
         *     swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data);
         *
         *     amount0Out: the amount of USDC to receive from swap.
         *     amount1Out: the amount of WETH to receive from swap.
         *     to: recipient address to receive the USDC tokens.
         *     data: leave it empty.
         */

        IUniswapV2Pair pair = IUniswapV2Pair(pool);
        
        // Get reserves
        (uint112 reserve0, uint112 reserve1,) = pair.getReserves();
        
        // Determine which token is USDC and which is WETH
        address token0 = pair.token0();
        
        // Target output: 1337 USDC (6 decimals)
        uint256 targetUsdcAmount = 1337 * 1e6;
        
        uint256 wethAmountIn;
        if (token0 == usdc) {
            // USDC is token0, WETH is token1
            // Calculate WETH input needed using: amountOut = (amountIn * 997 * reserveOut) / (reserveIn * 1000 + amountIn * 997)
            // Rearranging: amountIn = (reserveIn * amountOut * 1000) / ((reserveOut - amountOut) * 997)
            wethAmountIn = (reserve1 * targetUsdcAmount * 1000) / ((reserve0 - targetUsdcAmount) * 997) + 1;
            
            // Transfer WETH to pool
            IERC20(weth).transfer(pool, wethAmountIn);
            
            // Swap for exact USDC
            pair.swap(targetUsdcAmount, 0, address(this), "");
        } else {
            // WETH is token0, USDC is token1
            wethAmountIn = (reserve0 * targetUsdcAmount * 1000) / ((reserve1 - targetUsdcAmount) * 997) + 1;
            
            // Transfer WETH to pool
            IERC20(weth).transfer(pool, wethAmountIn);
            
            // Swap for exact USDC
            pair.swap(0, targetUsdcAmount, address(this), "");
        }
    }
}
