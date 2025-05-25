// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

contract OptimizedRequire {
    // Do not modify these variables
    uint256 constant COOLDOWN = 1 minutes;
    uint256 lastPurchaseTime;

    function purchaseToken() external payable {
        if (msg.value != 0.1 ether || block.timestamp <= lastPurchaseTime + COOLDOWN) {
            assembly {
                revert(0, 0)
            }
        }
        lastPurchaseTime = block.timestamp;
        // mint the user a token
    }
}