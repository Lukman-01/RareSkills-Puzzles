// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract ReadFromDynamicArray {
    uint256[] readMe;

    function setValue(uint256[] calldata x) external {
        readMe = x;
    }

    function main(uint256 index) external view returns (uint256) {
        assembly {
            // Calculate storage slot for array element
            // For dynamic arrays:
            // - Array length is stored at readMe.slot (slot 0)
            // - Array elements start at keccak256(readMe.slot)
            // - Element at index i is at keccak256(readMe.slot) + i
            
            // Store the array's storage slot in memory for hashing
            mstore(0x00, readMe.slot)
            
            // Calculate the starting slot for array data
            let dataSlot := keccak256(0x00, 0x20)
            
            // Add index to get the specific element's slot
            let elementSlot := add(dataSlot, index)
            
            // Load the value from storage
            let value := sload(elementSlot)
            
            // Store the value in memory and return it
            mstore(0x00, value)
            return(0x00, 0x20)
        }
    }
}