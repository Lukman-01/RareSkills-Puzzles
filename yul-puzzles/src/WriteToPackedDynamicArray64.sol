// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract WriteToPackedDynamicArray64 {
    uint64[] public writeHere;

    function main(uint64 v1, uint64 v2, uint64 v3, uint64 v4, uint64 v5) external {
        assembly {
            // Get the current length of the array from slot 0
            let currentLength := sload(0)
            
            // Update the length to add 5 new elements
            let newLength := add(currentLength, 5)
            sstore(0, newLength)
            
            // Calculate the storage location for array data
            // Array data starts at keccak256(0) since writeHere is at slot 0
            mstore(0x0, 0)  // Store slot number (0) in memory
            let dataStartSlot := keccak256(0x0, 0x20)  // Hash to get data start location
            
            // Since uint64 is 8 bytes, we can fit 4 elements per 32-byte slot
            // Calculate which slot the new elements should start at
            let elementSlot := add(dataStartSlot, div(currentLength, 4))
            let elementOffset := mod(currentLength, 4)  // Position within the slot (0-3)
            
            // Handle the case where we start writing mid-slot
            if gt(elementOffset, 0) {
                // Load existing data from the current slot
                let existingData := sload(elementSlot)
                
                // Calculate how many elements we can fit in the current slot
                let remainingSpace := sub(4, elementOffset)
                
                if eq(remainingSpace, 1) {
                    // Only space for 1 element in current slot
                    let newData := or(existingData, shl(mul(elementOffset, 64), v1))
                    sstore(elementSlot, newData)
                    
                    // Pack remaining 4 elements into next slot
                    let packedData := v2
                    packedData := or(packedData, shl(64, v3))
                    packedData := or(packedData, shl(128, v4))
                    packedData := or(packedData, shl(192, v5))
                    sstore(add(elementSlot, 1), packedData)
                }
                if eq(remainingSpace, 2) {
                    // Space for 2 elements in current slot
                    let newData := or(existingData, shl(mul(elementOffset, 64), v1))
                    newData := or(newData, shl(mul(add(elementOffset, 1), 64), v2))
                    sstore(elementSlot, newData)
                    
                    // Pack remaining 3 elements into next slot
                    let packedData := v3
                    packedData := or(packedData, shl(64, v4))
                    packedData := or(packedData, shl(128, v5))
                    sstore(add(elementSlot, 1), packedData)
                }
                if eq(remainingSpace, 3) {
                    // Space for 3 elements in current slot
                    let newData := or(existingData, shl(mul(elementOffset, 64), v1))
                    newData := or(newData, shl(mul(add(elementOffset, 1), 64), v2))
                    newData := or(newData, shl(mul(add(elementOffset, 2), 64), v3))
                    sstore(elementSlot, newData)
                    
                    // Pack remaining 2 elements into next slot
                    let packedData := v4
                    packedData := or(packedData, shl(64, v5))
                    sstore(add(elementSlot, 1), packedData)
                }
            }
            
            // Handle the case where we start at a slot boundary
            if eq(elementOffset, 0) {
                // Pack first 4 elements into one slot
                let packedData := v1
                packedData := or(packedData, shl(64, v2))
                packedData := or(packedData, shl(128, v3))
                packedData := or(packedData, shl(192, v4))
                sstore(elementSlot, packedData)
                
                // Store the 5th element in the next slot
                sstore(add(elementSlot, 1), v5)
            }
        }
    }
}