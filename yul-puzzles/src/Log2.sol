// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract Log2 {

    function main(uint256 x) external pure returns (uint256) {
        assembly {
            // Revert if x is 0
            if iszero(x) {
                revert(0, 0)
            }
            
            // Find the position of the most significant bit (log2 rounded down)
            let result := 0
            
            // Binary search to find the highest bit set
            // Check if any bits are set in the upper 128 bits
            if gt(x, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF) {
                x := shr(128, x)
                result := add(result, 128)
            }
            
            // Check upper 64 bits of remaining
            if gt(x, 0xFFFFFFFFFFFFFFFF) {
                x := shr(64, x)
                result := add(result, 64)
            }
            
            // Check upper 32 bits
            if gt(x, 0xFFFFFFFF) {
                x := shr(32, x)
                result := add(result, 32)
            }
            
            // Check upper 16 bits
            if gt(x, 0xFFFF) {
                x := shr(16, x)
                result := add(result, 16)
            }
            
            // Check upper 8 bits
            if gt(x, 0xFF) {
                x := shr(8, x)
                result := add(result, 8)
            }
            
            // Check upper 4 bits
            if gt(x, 0xF) {
                x := shr(4, x)
                result := add(result, 4)
            }
            
            // Check upper 2 bits
            if gt(x, 0x3) {
                x := shr(2, x)
                result := add(result, 2)
            }
            
            // Check last bit
            if gt(x, 0x1) {
                result := add(result, 1)
            }
            
            // Return the result
            mstore(0x00, result)
            return(0x00, 0x20)
        }
    }
}
