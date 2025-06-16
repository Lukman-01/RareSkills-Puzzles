// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract ReadFromMappingInStruct {
    struct RandomValues {
        uint256 someValue1;     // slot 1+0 = 1
        uint128 someValue2;     // slot 1+1 = 2 (lower 128 bits)
        uint128 someValue3;     // slot 1+1 = 2 (upper 128 bits)
        mapping(uint256 index => uint256) readMe;  // slot 1+2 = 3
        uint256 someValue4;     // slot 1+3 = 4
    }
    
    uint256 someValue5 = 7;    // slot 0
    RandomValues randValues;   // starts at slot 1

    function setValue(uint256 i, uint256 v, uint256 s1, uint128 s2, uint128 s3, uint256 s4, uint256 s5) external {
        randValues.someValue1 = s1;
        randValues.someValue2 = s2;
        randValues.someValue3 = s3;
        randValues.someValue4 = s4;
        randValues.readMe[i] = v;
        someValue5 = s5;
    }

    function main(uint256 index) external view returns (uint256) {
        assembly {
            // Storage layout:
            // slot 0: someValue5
            // slot 1: randValues.someValue1
            // slot 2: randValues.someValue2 (lower) + someValue3 (upper)
            // slot 3: randValues.readMe mapping base slot
            // slot 4: randValues.someValue4
            
            // For mapping storage location calculation:
            // keccak256(key || mapping_slot) where mapping_slot = 3
            
            // Store the index (key) at memory position 0x00
            mstore(0x00, index)
            // Store the mapping base slot (3) at memory position 0x20
            mstore(0x20, 3)
            
            // Calculate keccak256 hash of the 64 bytes (key + slot)
            let slot := keccak256(0x00, 0x40)
            
            // Load the value from the calculated storage slot
            let value := sload(slot)
            
            // Store the value in memory for return
            mstore(0x00, value)
            // Return the value (32 bytes from memory position 0x00)
            return(0x00, 0x20)
        }
    }
}