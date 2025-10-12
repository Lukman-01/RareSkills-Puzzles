// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IERC20.sol";

/**
 *
 *  ARBITRAGE A POOL
 *
 * Given two pools where the token pair represents the same underlying; WETH/USDC and WETH/USDT (the formal has the corect price, while the latter doesnt).
 * The challenge is to flash borrowing some USDC (>1000) from `flashLenderPool` to arbitrage the pool(s), then make profit by ensuring MyMevBot contract's USDC balance
 * is more than 0.
 *
 */
contract MyMevBot {
    address public immutable flashLenderPool;
    address public immutable weth;
    address public immutable usdc;
    address public immutable usdt;
    address public immutable router;
    bool public flashLoaned;

    constructor(address _flashLenderPool, address _weth, address _usdc, address _usdt, address _router) {
        flashLenderPool = _flashLenderPool;
        weth = _weth;
        usdc = _usdc;
        usdt = _usdt;
        router = _router;
    }

    function performArbitrage() public {
        // Flash loan USDC from the Uniswap V3 pool
        // The test adds 3M USDT and 10 WETH to ETH/USDT pool
        // This makes WETH very expensive in USDT terms (300k USDT per WETH)
        uint256 usdcToBorrow = 50000 * 1e6; // Borrow 50k USDC
        
        IUniswapV3Pool(flashLenderPool).flash(
            address(this),
            usdcToBorrow,
            0,
            ""
        );
    }

    function uniswapV3FlashCallback(uint256 _fee0, uint256, bytes calldata) external {
        callMeCallMe();

        // Get the amount of USDC we borrowed
        uint256 usdcBorrowed = IERC20(usdc).balanceOf(address(this));
        
        // Calculate amount to repay (borrowed amount + fee)
        uint256 usdcToRepay = usdcBorrowed + _fee0;
        
        // Arbitrage Strategy:
        // The ETH/USDT pool has too much USDT, making WETH very expensive there
        // We should buy WETH cheap in the normal pool and sell it expensive in the mispriced pool
        
        // Step 1: Swap USDC -> WETH on the correctly priced USDC/WETH pool (buy WETH at normal price)
        IERC20(usdc).approve(router, usdcBorrowed);
        
        address[] memory path1 = new address[](2);
        path1[0] = usdc;
        path1[1] = weth;
        
        uint256[] memory amounts1 = IUniswapV2Router(router).swapExactTokensForTokens(
            usdcBorrowed,
            0,
            path1,
            address(this),
            block.timestamp + 300
        );
        
        uint256 wethReceived = amounts1[1];
        
        // Step 2: Swap WETH -> USDT on the mispriced ETH/USDT pool (sell WETH at inflated price)
        IERC20(weth).approve(router, wethReceived);
        
        address[] memory path2 = new address[](2);
        path2[0] = weth;
        path2[1] = usdt;
        
        uint256[] memory amounts2 = IUniswapV2Router(router).swapExactTokensForTokens(
            wethReceived,
            0,
            path2,
            address(this),
            block.timestamp + 300
        );
        
        uint256 usdtReceived = amounts2[1];
        
        // Step 3: Swap USDT -> USDC (stablecoin swap, approximately 1:1)
        IERC20(usdt).approve(router, usdtReceived);
        
        address[] memory path3 = new address[](2);
        path3[0] = usdt;
        path3[1] = usdc;
        
        IUniswapV2Router(router).swapExactTokensForTokens(
            usdtReceived,
            usdcToRepay,
            path3,
            address(this),
            block.timestamp + 300
        );
        
        // Repay the flash loan
        IERC20(usdc).transfer(flashLenderPool, usdcToRepay);
        
        // Any remaining USDC is our profit
    }

    function callMeCallMe() private {
        uint256 usdcBal = IERC20(usdc).balanceOf(address(this));
        require(msg.sender == address(flashLenderPool), "not callback");
        require(flashLoaned = usdcBal >= 1000 * 1e6, "FlashLoan less than 1,000 USDC.");
    }
}

interface IUniswapV3Pool {
    /**
     * recipient: the address which will receive the token0 and/or token1 amounts.
     * amount0: the amount of token0 to send.
     * amount1: the amount of token1 to send.
     * data: any data to be passed through to the callback.
     */
    function flash(address recipient, uint256 amount0, uint256 amount1, bytes calldata data) external;
}

interface IUniswapV2Router {
    /**
     *     amountIn: the amount to use for swap.
     *     amountOutMin: the minimum amount of output tokens that must be received for the transaction not to revert.
     *     path: an array of token addresses. In our case, WETH and USDC.
     *     to: recipient address to receive the liquidity tokens.
     *     deadline: timestamp after which the transaction will revert.
     */
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);
}
