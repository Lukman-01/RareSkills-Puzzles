// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract MaxOfTwoValues {
    function main(uint256 x, uint256 y) external pure returns (uint256) {
        assembly {
            // Initialize result with y as default
            let result := y
            
            // Check if x is greater than y
            if gt(x, y) {
                result := x
            }
            
            // Store result in memory and return
            mstore(0x00, result)
            return(0x00, 0x20)
        }
    }
}