// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract WriteToPacked128 {
    uint128 public writeHere = 1;
    uint128 public someValue = 7;

    function main(uint256 v) external {
        assembly {
            // Load the current packed storage slot (slot 0)
            let packed := sload(0)
            
            // Clear the lower 128 bits (writeHere) while preserving upper 128 bits (someValue)
            // Create mask: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
            let mask := shl(128, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
            let clearedPacked := and(packed, mask)
            
            // Mask the new value to 128 bits to ensure it doesn't overflow
            let maskedValue := and(v, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
            
            // Combine: preserved upper bits OR new lower bits
            let newPacked := or(clearedPacked, maskedValue)
            
            // Store the updated packed value back to slot 0
            sstore(0, newPacked)
        }
    }
}