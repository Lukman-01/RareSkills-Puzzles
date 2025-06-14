// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract ReadFromMapping {
    mapping(uint256 index => uint256) readMe;

    function setValue(uint256 index, uint256 value) external {
        readMe[index] = value;
    }

    function main(uint256 index) external view returns (uint256) {
        assembly {
            // For mappings, the storage slot is calculated as:
            // keccak256(key || mapping_slot)
            // where || means concatenation
            
            // Store the key (index) in memory at position 0x00
            mstore(0x00, index)
            
            // Store the mapping's storage slot in memory at position 0x20
            mstore(0x20, readMe.slot)
            
            // Calculate the storage slot for this key
            // Hash 64 bytes (32 bytes key + 32 bytes slot)
            let storageSlot := keccak256(0x00, 0x40)
            
            // Load the value from the calculated storage slot
            let value := sload(storageSlot)
            
            // Store the value in memory and return it
            mstore(0x00, value)
            return(0x00, 0x20)
        }
    }
}