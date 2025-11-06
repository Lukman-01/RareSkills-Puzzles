// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract ReturnTupleOfStringUnit256 {
    function main() external pure returns (string memory, uint256) {
        assembly {
            // Get free memory pointer
            let ptr := mload(0x40)
            
            // ABI encoding for (string, uint256): ("RareSkills", 420)
            // Structure:
            // [0x00-0x1F]: offset to string (0x40)
            // [0x20-0x3F]: uint256 value (420)
            // [0x40-0x5F]: length of string (10)
            // [0x60-0x7F]: string data "RareSkills"
            
            // Store offset to string
            mstore(ptr, 0x40)
            
            // Store uint256 value
            mstore(add(ptr, 0x20), 420)
            
            // Store string "RareSkills"
            mstore(add(ptr, 0x40), 10)         // length of "RareSkills"
            mstore(add(ptr, 0x60), "RareSkills\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00")
            
            // Update free memory pointer
            mstore(0x40, add(ptr, 0x80))
            
            // Return total size: 0x80 (128 bytes)
            return(ptr, 0x80)
        }
    }
}
