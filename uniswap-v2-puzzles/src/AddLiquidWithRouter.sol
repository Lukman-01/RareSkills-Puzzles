// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IUniswapV2Pair.sol";

interface IUniswapV2Router {
    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
}

interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);
    function balanceOf(address owner) external view returns (uint256);
}

contract AddLiquidWithRouter {
    /**
     *  ADD LIQUIDITY WITH ROUTER EXERCISE
     *
     *  The contract has an initial balance of 1000 USDC and 1 ETH.
     *  Mint a position (deposit liquidity) in the pool USDC/ETH to `msg.sender`.
     *  The challenge is to use Uniswapv2 router to add liquidity to the pool.
     *
     */
    address public immutable router;

    constructor(address _router) {
        router = _router;
    }

    function addLiquidityWithRouter(address usdcAddress, uint256 deadline) public {
        // Get actual balances
        uint256 usdcBalance = IERC20(usdcAddress).balanceOf(address(this));
        uint256 ethBalance = address(this).balance;

        // Approve router to spend USDC
        IERC20(usdcAddress).approve(router, usdcBalance);

        // Set very low minimums to allow the router to adjust amounts based on pool ratio
        // The router will use as much as possible while maintaining the correct ratio
        uint256 usdcAmountMin = 1; // Minimal slippage protection
        uint256 ethAmountMin = 1;   // Minimal slippage protection

        // Add liquidity to USDC/ETH pool via router
        IUniswapV2Router(router).addLiquidityETH{value: ethBalance}(
            usdcAddress,
            usdcBalance,
            usdcAmountMin,
            ethAmountMin,
            msg.sender,
            deadline
        );
    }

    receive() external payable {}
}
