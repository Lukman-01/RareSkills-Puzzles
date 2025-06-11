// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract IsPrime {
    function main(uint256 x) external pure returns (bool) {
        assembly {
            let result := 0  // false by default
            
            // Handle special cases
            if eq(x, 2) { result := 1 }
            if eq(x, 3) { result := 1 }
            
            // If x < 2, it's not prime
            if lt(x, 2) { result := 0 }
            
            // If x > 3, check for primality
            if gt(x, 3) {
                result := 1  // assume prime until proven otherwise
                
                // Check if divisible by 2
                if eq(mod(x, 2), 0) { result := 0 }
                
                // Check if divisible by 3
                if eq(mod(x, 3), 0) { result := 0 }
                
                // If still potentially prime, check odd divisors from 5
                if eq(result, 1) {
                    let i := 5
                    let limit := div(x, 2)
                    
                    // Loop from 5 to x/2, incrementing by 2 (odd numbers only)
                    for { } lt(i, add(limit, 1)) { i := add(i, 2) } {
                        if eq(mod(x, i), 0) {
                            result := 0
                            break
                        }
                    }
                }
            }
            
            // Store result in memory and return
            mstore(0x00, result)
            return(0x00, 0x20)
        }
    }
}