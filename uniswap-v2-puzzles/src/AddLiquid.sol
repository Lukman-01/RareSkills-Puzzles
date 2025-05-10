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

        // Expected balances
        uint256 usdcBalance = 1000 * 10 ** 6; // 1000 USDC (6 decimals)
        uint256 wethBalance = 1 * 10 ** 18;   // 1 WETH (18 decimals)

        // Check actual balances
        require(IERC20(usdc).balanceOf(address(this)) >= usdcBalance, "Insufficient USDC balance");
        require(IERC20(weth).balanceOf(address(this)) >= wethBalance, "Insufficient WETH balance");
        require(usdcReserve > 0 && wethReserve > 0, "Invalid pool reserves");

        // Calculate WETH amount to match pool ratio (usdcReserve:wethReserve = usdcAmount:wethAmount)
        uint256 wethAmount = (usdcBalance * wethReserve) / usdcReserve;

        // Adjust for limiting token
        uint256 usdcAmount;
        if (wethAmount > wethBalance) {
            // WETH is limiting
            wethAmount = wethBalance;
            usdcAmount = (wethAmount * usdcReserve) / wethReserve;
        } else {
            // USDC is limiting or perfect match
            usdcAmount = usdcBalance;
        }

        // Transfer tokens to the pool
        require(IERC20(usdc).transfer(pool, usdcAmount), "USDC transfer failed");
        require(IERC20(weth).transfer(pool, wethAmount), "WETH transfer failed");

        // Mint liquidity tokens to msg.sender
        pair.mint(msg.sender);
    }
}