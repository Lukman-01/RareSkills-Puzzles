// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract DoubleOrNothing {
    function main(uint256 x) external pure returns (uint256) {
        assembly {
            // Check if x < 11 (equivalent to x ≤ 10)
            // If true, return 2 * x, otherwise return 0
            let result := 0
            
            // Check if x is less than 11
            if lt(x, 11) {
                result := mul(x, 2)
            }
            
            // Store result in memory and return
            mstore(0x00, result)
            return(0x00, 0x20)
        }
    }
}