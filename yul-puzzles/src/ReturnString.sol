// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract ReturnString {
    function main() external pure returns (string memory) {
        assembly {
            // String: "Hello, RareSkills" is 18 characters
            // Memory layout for string:
            // [0x00-0x1F]: pointer to string data (0x20 for our case)
            // [0x20-0x3F]: length of string (18 = 0x12)
            // [0x40-...]: actual string data
            
            // Get free memory pointer
            let ptr := mload(0x40)
            
            // Store the offset to the string data (32 bytes ahead)
            mstore(ptr, 0x20)
            
            // Store the length of the string (18 characters)
            mstore(add(ptr, 0x20), 0x12)
            
            // Store the string "Hello, RareSkills"
            // "Hello, RareSkills" in hex
            mstore(add(ptr, 0x40), "Hello, RareSkills\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00")
            
            // Update free memory pointer
            mstore(0x40, add(ptr, 0x60))
            
            // Return pointer and size
            return(ptr, 0x60)
        }
    }
}
