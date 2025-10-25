// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract ReturnTupleOfString {
    function main() external pure returns (string memory, string memory) {
        assembly {
            // Get free memory pointer
            let ptr := mload(0x40)
            
            // ABI encoding for two strings: ("Hello", "RareSkills")
            // Structure:
            // [0x00-0x1F]: offset to first string (0x40)
            // [0x20-0x3F]: offset to second string (calculate based on first string)
            // [0x40-0x5F]: length of first string (5)
            // [0x60-0x7F]: first string data "Hello"
            // [0x80-0x9F]: length of second string (10)
            // [0xA0-0xBF]: second string data "RareSkills"
            
            // String1: "Hello" (5 bytes)
            // String2: "RareSkills" (10 bytes)
            
            // Store offsets
            mstore(ptr, 0x40)                  // offset to first string
            mstore(add(ptr, 0x20), 0x80)       // offset to second string (0x40 + 0x20 + 0x20)
            
            // Store first string "Hello"
            mstore(add(ptr, 0x40), 5)          // length of "Hello"
            mstore(add(ptr, 0x60), "Hello\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00")
            
            // Store second string "RareSkills"
            mstore(add(ptr, 0x80), 10)         // length of "RareSkills"
            mstore(add(ptr, 0xA0), "RareSkills\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00")
            
            // Update free memory pointer
            mstore(0x40, add(ptr, 0xC0))
            
            // Return total size: 0xC0 (192 bytes)
            return(ptr, 0xC0)
        }
    }
}
