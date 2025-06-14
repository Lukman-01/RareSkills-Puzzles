// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract WriteToDynamicArray {
    uint256[] writeHere;

    function main(uint256[] memory x) external {
        assembly {
            // Memory layout of dynamic array x:
            // - x points to the length (32 bytes)
            // - x + 0x20 points to first element
            // - x + 0x40 points to second element, etc.
            
            // Load the length of the array from memory
            let arrayLength := mload(x)
            
            // Store the length in the storage slot for writeHere
            sstore(writeHere.slot, arrayLength)
            
            // Calculate the starting storage slot for array data
            mstore(0x00, writeHere.slot)
            let dataSlot := keccak256(0x00, 0x20)
            
            // Copy each element from memory to storage
            for { let i := 0 } lt(i, arrayLength) { i := add(i, 1) } {
                // Calculate memory position: x + 0x20 + (i * 0x20)
                let memoryPos := add(add(x, 0x20), mul(i, 0x20))
                
                // Load value from memory
                let value := mload(memoryPos)
                
                // Calculate storage position: dataSlot + i
                let storagePos := add(dataSlot, i)
                
                // Store value in storage
                sstore(storagePos, value)
            }
        }
    }

    function getter() external view returns (uint256[] memory) {
        return writeHere;
    }
}