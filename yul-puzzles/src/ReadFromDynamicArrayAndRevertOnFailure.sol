// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract ReadFromDynamicArrayAndRevertOnFailure {
    uint256[] readMe;

    function setValue(uint256[] calldata x) external {
        readMe = x;
    }

    function main(int256 index) external view returns (uint256) {
        assembly {
            // Check if index is negative
            if slt(index, 0) {
                // Revert with Solidity panic
                // Store selector (first 4 bytes) and error code (next 32 bytes)
                mstore(0x00, shl(224, 0x4e487b71)) // Left shift selector to first 4 bytes
                mstore(0x04, 0x32) // Error code: array out of bounds
                revert(0x00, 0x24)
            }
            
            // Load array length from storage slot 0 (readMe.slot)
            let arrayLength := sload(readMe.slot)
            
            // Check if index >= array length (out of bounds)
            if iszero(lt(index, arrayLength)) {
                // Revert with Solidity panic
                // Store selector (first 4 bytes) and error code (next 32 bytes)
                mstore(0x00, shl(224, 0x4e487b71)) // Left shift selector to first 4 bytes
                mstore(0x04, 0x32) // Error code: array out of bounds
                revert(0x00, 0x24)
            }
            
            // Calculate storage slot for array element
            // For dynamic arrays, elements start at keccak256(array.slot)
            mstore(0x00, readMe.slot)
            let dataSlot := keccak256(0x00, 0x20)
            
            // Add index to get the specific element's slot
            let elementSlot := add(dataSlot, index)
            
            // Load and return the value
            let value := sload(elementSlot)
            mstore(0x00, value)
            return(0x00, 0x20)
        }
    }
}