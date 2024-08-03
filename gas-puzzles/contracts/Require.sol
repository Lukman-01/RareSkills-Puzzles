// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

contract OptimizedRequire {
    // Do not modify these variables
    uint256 constant COOLDOWN = 1 minutes;
    uint256 lastPurchaseTime;

    error CannotPurchase(string message);

    // Optimize this function
    function purchaseToken() external payable {
        // Check if the sent value is 0.1 ether and the cooldown period has passed
        if (msg.value != 0.1 ether || block.timestamp <= lastPurchaseTime + COOLDOWN) {
            // Revert with a custom error message if conditions are not met
            revert CannotPurchase("cannot purchase");
        }

        // Update the last purchase time to the current block timestamp
        lastPurchaseTime = block.timestamp;

        // Mint the user a token (implementation not provided)
    }
}
