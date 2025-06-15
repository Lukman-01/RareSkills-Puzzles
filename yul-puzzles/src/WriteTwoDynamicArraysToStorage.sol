// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract WriteTwoDynamicArraysToStorage {
    uint256[] public writeHere1;
    uint256[] public writeHere2;

    function main(uint256[] calldata x, uint256[] calldata y) external {
        assembly {
            // Get the length of array x and y
            let xLen := x.length
            let yLen := y.length
            
            // Store length of x in writeHere1.slot (slot 0)
            sstore(writeHere1.slot, xLen)
            
            // Store length of y in writeHere2.slot (slot 1)  
            sstore(writeHere2.slot, yLen)
            
            // Calculate storage locations for array data
            // For writeHere1 (slot 0)
            mstore(0x00, writeHere1.slot)
            let writeHere1DataSlot := keccak256(0x00, 0x20)
            
            // For writeHere2 (slot 1)
            mstore(0x00, writeHere2.slot)
            let writeHere2DataSlot := keccak256(0x00, 0x20)
            
            // Copy array x to writeHere1
            for { let i := 0 } lt(i, xLen) { i := add(i, 1) } {
                let value := calldataload(add(x.offset, mul(i, 0x20)))
                sstore(add(writeHere1DataSlot, i), value)
            }
            
            // Copy array y to writeHere2
            for { let i := 0 } lt(i, yLen) { i := add(i, 1) } {
                let value := calldataload(add(y.offset, mul(i, 0x20)))
                sstore(add(writeHere2DataSlot, i), value)
            }
        }
    }
}