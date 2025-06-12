// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract MaxOfArray {
    function main(uint256[] memory arr) external pure returns (uint256) {
        assembly {
            // Get the length of the array
            let length := mload(arr)
            
            // Revert if array is empty
            if iszero(length) {
                revert(0, 0)
            }
            
            // Initialize max with the first element
            // First element is at offset 0x20 (32 bytes) from the start of arr
            let max := mload(add(arr, 0x20))
            
            // Loop through the rest of the array starting from index 1
            let i := 1
            for { } lt(i, length) { i := add(i, 1) } {
                // Calculate the memory offset for arr[i]
                // Each element is 32 bytes, so offset = 0x20 + (i * 0x20)
                let offset := add(0x20, mul(i, 0x20))
                let current := mload(add(arr, offset))
                
                // Update max if current element is greater
                if gt(current, max) {
                    max := current
                }
            }
            
            // Store result in memory and return
            mstore(0x00, max)
            return(0x00, 0x20)
        }
    }
}