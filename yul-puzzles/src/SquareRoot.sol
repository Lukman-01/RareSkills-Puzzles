// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract SquareRoot {
    function main(uint256 x) external pure returns (uint256) {
        assembly {
            // Handle special cases
            switch x
            case 0 {
                mstore(0x00, 0)
                return(0x00, 0x20)
            }
            case 1 {
                mstore(0x00, 1)
                return(0x00, 0x20)
            }
            default {
                // Newton's method (Babylonian method)
                // Start with initial guess: x / 2
                let guess := div(x, 2)
                
                // Iterate until convergence
                for { } gt(guess, 0) { } {
                    // Calculate new guess: (guess + x/guess) / 2
                    let newGuess := div(add(guess, div(x, guess)), 2)
                    
                    // Check for convergence (if guess doesn't change)
                    if iszero(lt(newGuess, guess)) {
                        break
                    }
                    
                    guess := newGuess
                }
                
                // Return the result
                mstore(0x00, guess)
                return(0x00, 0x20)
            }
        }
    }
}
