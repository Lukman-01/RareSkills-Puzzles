// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.13;

// import "./interfaces/IUniswapV2Pair.sol";

// contract AddLiquid {
//     /**
//      *  ADD LIQUIDITY WITHOUT ROUTER EXERCISE
//      *
//      *  The contract has an initial balance of 1000 USDC and 1 WETH.
//      *  Mint a position (deposit liquidity) in the pool USDC/WETH to msg.sender.
//      *  The challenge is to provide the same ratio as the pool then call the mint function in the pool contract.
//      *
//      */
//     function addLiquidity(address usdc, address weth, address pool, uint256 usdcReserve, uint256 wethReserve) public {
//         // Create an instance of the IUniswapV2Pair interface using the provided pool address
//         IUniswapV2Pair pair = IUniswapV2Pair(pool);

//         // Get the current reserves of the pool
//         (uint112 reserve0, uint112 reserve1,) = pair.getReserves();

//         // Determine which token is USDC and which is WETH in the pool
//         address token0 = pair.token0();
//         address token1 = pair.token1();
//         uint256 currentUsdcReserve = (token0 == usdc) ? reserve0 : reserve1;
//         uint256 currentWethReserve = (token0 == weth) ? reserve0 : reserve1;

//         // Calculate the amount of USDC and WETH to add to maintain the same ratio as the current reserves
//         uint256 amountUsdcToAdd = (currentUsdcReserve * wethReserve) / currentWethReserve;
//         uint256 amountWethToAdd = wethReserve;

//         // Ensure the contract has at least 1000 USDC and 1 WETH
//         require(IERC20(usdc).balanceOf(address(this)) >= 1000 * 10**6, "Insufficient USDC balance");
//         require(IERC20(weth).balanceOf(address(this)) >= 1 * 10**18, "Insufficient WETH balance");

//         // Approve the pool to spend the required amount of USDC
//         IERC20(usdc).approve(pool, amountUsdcToAdd);

//         // Approve the pool to spend the required amount of WETH
//         IERC20(weth).approve(pool, amountWethToAdd);

//         // Transfer the calculated amount of USDC to the pool
//         IERC20(usdc).transferFrom(address(this), pool, amountUsdcToAdd);

//         // Transfer the calculated amount of WETH to the pool
//         IERC20(weth).transferFrom(address(this), pool, amountWethToAdd);

//         // Call the mint function on the pair instance to mint liquidity tokens to msg.sender
//         pair.mint(msg.sender);

//         // Return success (optional, depending on your needs)
//         // emit LiquidityAdded(msg.sender, amountUsdcToAdd, amountWethToAdd);
//     }

// }


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IUniswapV2Pair.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; // Import the IERC20 interface

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

        // Get the current reserves of the pool
        (uint112 reserve0, uint112 reserve1,) = pair.getReserves();

        // Determine which token is USDC and which is WETH in the pool
        address token0 = pair.token0();
        address token1 = pair.token1();
        uint256 currentUsdcReserve = (token0 == usdc) ? reserve0 : reserve1;
        uint256 currentWethReserve = (token0 == weth) ? reserve0 : reserve1;

        // Calculate the amount of USDC and WETH to add to maintain the same ratio as the current reserves
        uint256 amountUsdcToAdd = (currentUsdcReserve * wethReserve) / currentWethReserve;
        uint256 amountWethToAdd = wethReserve;

        // Ensure the contract has at least 1000 USDC and 1 WETH
        require(IERC20(usdc).balanceOf(address(this)) >= 1000 * 10**6, "Insufficient USDC balance");
        require(IERC20(weth).balanceOf(address(this)) >= 1 * 10**18, "Insufficient WETH balance");

        // Approve the pool to spend the required amount of USDC
        IERC20(usdc).approve(pool, amountUsdcToAdd);

        // Approve the pool to spend the required amount of WETH
        IERC20(weth).approve(pool, amountWethToAdd);

        // Transfer the calculated amount of USDC to the pool
        IERC20(usdc).transferFrom(address(this), pool, amountUsdcToAdd);

        // Transfer the calculated amount of WETH to the pool
        IERC20(weth).transferFrom(address(this), pool, amountWethToAdd);

        // Call the mint function on the pair instance to mint liquidity tokens to msg.sender
        pair.mint(msg.sender);

        // Return success (optional, depending on your needs)
        // emit LiquidityAdded(msg.sender, amountUsdcToAdd, amountWethToAdd);
    }
}
