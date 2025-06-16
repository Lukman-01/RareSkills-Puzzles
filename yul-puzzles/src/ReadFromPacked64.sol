// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract ReadFromPacked64 {
    uint64 someValue1;
    uint64 someValue2;
    uint64 readMe;
    uint64 someValue3;

    function setValue(uint64 v1, uint64 v2, uint64 v3, uint64 v4) external {
        someValue1 = v1;
        someValue2 = v2;
        readMe = v3;
        someValue3 = v4;
    }

    function main() external view returns (uint256) {
        assembly {
            // Load the entire storage slot 0 (contains all four uint64 values)
            let slot := sload(0)
            
            // readMe is the third uint64, so it starts at bit position 128 (2 * 64)
            // Shift right by 128 bits to move readMe to the least significant position
            let shifted := shr(128, slot)
            
            // Mask to keep only the lower 64 bits (readMe value)
            let mask := 0xFFFFFFFFFFFFFFFF  // 64 bits of 1s
            let result := and(shifted, mask)
            
            // Return the extracted value
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }
}