// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract WriteDynamicArrayToStorage {
    uint256[] public writeHere;

    function main(uint256[] calldata x) external {
        assembly {
            // Get the length of array x
            let xLen := x.length
            
            // Store length of x in writeHere.slot (slot 0)
            sstore(writeHere.slot, xLen)
            
            // Calculate storage location for array data
            // Dynamic arrays store data at keccak256(slot)
            mstore(0x00, writeHere.slot)
            let writeHereDataSlot := keccak256(0x00, 0x20)
            
            // Copy array x to writeHere
            for { let i := 0 } lt(i, xLen) { i := add(i, 1) } {
                let value := calldataload(add(x.offset, mul(i, 0x20)))
                sstore(add(writeHereDataSlot, i), value)
            }
        }
    }
}