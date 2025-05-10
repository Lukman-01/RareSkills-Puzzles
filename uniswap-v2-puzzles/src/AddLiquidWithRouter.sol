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
        // Contract's initial balances
        uint256 usdcAmountDesired = 1000 * 10 ** 6; // 1000 USDC (6 decimals)
        uint256 ethAmountDesired = 1 * 10 ** 18;    // 1 ETH (18 decimals)

        // Approve router to spend USDC
        IERC20(usdcAddress).approve(router, usdcAmountDesired);

        // Set slippage protection (e.g., 1% below desired amounts)
        uint256 usdcAmountMin = (usdcAmountDesired * 99) / 100; // 99% of USDC
        uint256 ethAmountMin = (ethAmountDesired * 99) / 100;   // 99% of ETH

        // Add liquidity to USDC/ETH pool via router
        IUniswapV2Router(router).addLiquidityETH{value: ethAmountDesired}(
            usdcAddress,
            usdcAmountDesired,
            usdcAmountMin,
            ethAmountMin,
            msg.sender,
            deadline
        );
    }

    receive() external payable {}
}