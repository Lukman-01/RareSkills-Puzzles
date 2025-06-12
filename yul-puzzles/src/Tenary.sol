// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract Tenary {
    uint256 public result;

    function main(uint256 a, uint256 b, uint256 c) external {
        assembly {
            let value := 30  // default value
            
            // Check if a > b
            if gt(a, b) {
                value := 10
            }
            // Else if b > c (only check if a <= b)
            if and(not(gt(a, b)), gt(b, c)) {
                value := 20
            }
            
            // Store the result in storage slot 0 (result variable)
            sstore(0, value)
        }
    }
}