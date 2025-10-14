// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract FizzBuzz {
    function main(uint256 num) external pure returns (string memory) {
        assembly {
            // Get free memory pointer
            let ptr := mload(0x40)
            
            // Check if divisible by 15 (both 3 and 5)
            let rem15 := mod(num, 15)
            
            if iszero(rem15) {
                // Return "fizzbuzz"
                mstore(ptr, 0x20)           // offset to string
                mstore(add(ptr, 0x20), 8)   // length of "fizzbuzz"
                mstore(add(ptr, 0x40), "fizzbuzz")
                return(ptr, 0x60)
            }
            
            // Check if divisible by 3
            let rem3 := mod(num, 3)
            
            if iszero(rem3) {
                // Return "fizz"
                mstore(ptr, 0x20)           // offset to string
                mstore(add(ptr, 0x20), 4)   // length of "fizz"
                mstore(add(ptr, 0x40), "fizz")
                return(ptr, 0x60)
            }
            
            // Check if divisible by 5
            let rem5 := mod(num, 5)
            
            if iszero(rem5) {
                // Return "buzz"
                mstore(ptr, 0x20)           // offset to string
                mstore(add(ptr, 0x20), 4)   // length of "buzz"
                mstore(add(ptr, 0x40), "buzz")
                return(ptr, 0x60)
            }
            
            // Return empty string ""
            mstore(ptr, 0x20)           // offset to string
            mstore(add(ptr, 0x20), 0)   // length of ""
            return(ptr, 0x40)
        }
    }
}
