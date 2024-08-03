// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

contract OptimizedRequire {
    // Do not modify these variables
    uint256 constant COOLDOWN = 1 minutes;
    uint256 lastPurchaseTime;

    /*
    // Original unoptimized function
    function purchaseToken() external payable {
        require(
            msg.value == 0.1 ether &&
                block.timestamp > lastPurchaseTime + COOLDOWN,
            'cannot purchase'
        );
        lastPurchaseTime = block.timestamp;
        // mint the user a token
    }
    */

    // Optimized function using a custom error and if-statement
    error CannotPurchase(string message);

    function purchaseToken() external payable {
        if (msg.value != 0.1 ether || block.timestamp <= lastPurchaseTime + COOLDOWN) {
            revert CannotPurchase("cannot purchase");
        }
        lastPurchaseTime = block.timestamp;
        // mint the user a token
    }

    /*
    Explanation:
    - Custom Error: Using a custom error `CannotPurchase` instead of `require` with a string message 
      is more gas-efficient. Reverting with a custom error is cheaper in terms of gas compared to 
      using a `require` statement with a string.
    - Consolidated Condition Check: The conditions are checked within a single `if` statement. If 
      the conditions are not met, the function reverts with the custom error.
    - Efficiency: These changes reduce gas consumption by avoiding the overhead associated with 
      the `require` statement and its string message, and by using a single condition check.

    This optimization helps in saving gas while maintaining the same functionality and readability.
    */
}
