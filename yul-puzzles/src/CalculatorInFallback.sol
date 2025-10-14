// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract CalculatorInFallback {
    uint256 public result;

    fallback() external {
        assembly {
            // Load the function selector (first 4 bytes of calldata)
            let selector := shr(224, calldataload(0))
            
            // Load the two parameters (at positions 4 and 36)
            let x := calldataload(4)
            let y := calldataload(36)
            
            // Compare selector and execute appropriate operation
            // add(uint256,uint256) -> 0x771602f7
            if eq(selector, 0x771602f7) {
                sstore(0, add(x, y))
            }
            
            // sub(uint256,uint256) -> 0xb67d77c5
            if eq(selector, 0xb67d77c5) {
                sstore(0, sub(x, y))
            }
            
            // mul(uint256,uint256) -> 0xc8a4ac9c
            if eq(selector, 0xc8a4ac9c) {
                sstore(0, mul(x, y))
            }
            
            // div(uint256,uint256) -> 0xa391c15b
            if eq(selector, 0xa391c15b) {
                sstore(0, div(x, y))
            }
        }
    }
}
