// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract ReadFromDoubleMapping {
    mapping(address user => mapping(address token => uint256)) public balances;

    function setValue(address user, address token, uint256 value) external {
        balances[user][token] = value;
    }

    function main(address user, address token) external view returns (uint256) {
        assembly {
            // For nested mappings: mapping(K1 => mapping(K2 => V))
            // The storage slot is calculated as:
            // keccak256(K2 || keccak256(K1 || mapping_slot))
            
            // Step 1: Calculate the inner mapping slot
            // This is keccak256(user || balances.slot)
            mstore(0x00, user)                    // Store user address (key1)
            mstore(0x20, balances.slot)           // Store mapping slot (0)
            let innerMappingSlot := keccak256(0x00, 0x40)  // Hash 64 bytes
            
            // Step 2: Calculate the final storage slot
            // This is keccak256(token || innerMappingSlot)
            mstore(0x00, token)                   // Store token address (key2)
            mstore(0x20, innerMappingSlot)        // Store inner mapping slot
            let storageSlot := keccak256(0x00, 0x40)       // Hash 64 bytes
            
            // Step 3: Load the value from the calculated storage slot
            let value := sload(storageSlot)
            
            // Step 4: Store the value in memory and return it
            mstore(0x00, value)
            return(0x00, 0x20)
        }
    }
}