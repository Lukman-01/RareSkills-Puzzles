// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IUniswapV2Pair.sol";
import "./interfaces/IERC20.sol";

contract AddLiquid {
    /**
     *  ADD LIQUIDITY WITHOUT ROUTER EXERCISE
     *
     *  The contract has an initial balance of 1000 USDC and 1 WETH.
     *  Mint a position (deposit liquidity) in the pool USDC/WETH to msg.sender.
     *  The challenge is to provide the same ratio as the pool then call the mint function in the pool contract.
     *
     */
    function addLiquidity(address usdc, address weth, address pool, uint256 usdcReserve, uint256 wethReserve) public {
        IUniswapV2Pair pair = IUniswapV2Pair(pool);

        // Get actual balances
        uint256 usdcBalance = IERC20(usdc).balanceOf(address(this));
        uint256 wethBalance = IERC20(weth).balanceOf(address(this));

        // Calculate optimal amounts based on pool reserves
        // We need to maintain the ratio: usdcAmount/wethAmount = usdcReserve/wethReserve
        uint256 wethAmount = (usdcBalance * wethReserve) / usdcReserve;
        uint256 usdcAmount;
        
        if (wethAmount > wethBalance) {
            // WETH is the limiting factor
            wethAmount = wethBalance;
            usdcAmount = (wethAmount * usdcReserve) / wethReserve;
        } else {
            // USDC is the limiting factor or perfect match
            usdcAmount = usdcBalance;
        }

        // Transfer tokens to the pool
        IERC20(usdc).transfer(pool, usdcAmount);
        IERC20(weth).transfer(pool, wethAmount);

        // Mint liquidity tokens to msg.sender
        pair.mint(msg.sender);
    }
}
