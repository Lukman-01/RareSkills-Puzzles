// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract ReturnTupleOfUint256String {
    function main() external pure returns (uint256, string memory) {
        assembly {
            // Get free memory pointer
            let ptr := mload(0x40)
            
            // ABI encoding for (uint256, string): (420, "RareSkills")
            // Structure:
            // [0x00-0x1F]: uint256 value (420)
            // [0x20-0x3F]: offset to string (0x40)
            // [0x40-0x5F]: length of string (10)
            // [0x60-0x7F]: string data "RareSkills"
            
            // Store uint256 value
            mstore(ptr, 420)
            
            // Store offset to string
            mstore(add(ptr, 0x20), 0x40)
            
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
