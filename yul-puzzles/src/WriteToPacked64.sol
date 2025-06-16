// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract WriteToPacked64 {
    uint64 public someValue1 = 7;
    uint64 public writeHere = 1;
    uint64 public someValue2 = 7;
    uint64 public someValue3 = 7;

    function main(uint256 v) external {
        assembly {
            // Load the current storage slot 0
            let currentSlot := sload(0)
            
            // Create a mask with 64 ones (for clearing writeHere field)
            let mask64 := 0xFFFFFFFFFFFFFFFF
            
            // Shift the mask to position 64-127 (writeHere position)
            let clearMask := shl(64, mask64)
            
            // Invert to get a mask that clears only the writeHere field
            clearMask := not(clearMask)
            
            // Clear the writeHere field in the current slot
            let clearedSlot := and(currentSlot, clearMask)
            
            // Ensure the new value fits in 64 bits
            let newValue := and(v, 0xFFFFFFFFFFFFFFFF)
            
            // Shift the new value to the correct position (bits 64-127)
            let shiftedNewValue := shl(64, newValue)
            
            // Combine the cleared slot with the new value
            let updatedSlot := or(clearedSlot, shiftedNewValue)
            
            // Store the updated slot back to storage
            sstore(0, updatedSlot)
        }
    }
}