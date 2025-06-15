// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract ReadFromPacked128 {
    uint128 someValue;
    uint128 readMe;

    function setValue(uint128 v1, uint128 v2) external {
        someValue = v1;
        readMe = v2;
    }

    function main() external view returns (uint256) {
        assembly {
            // Load the full 32-byte storage slot (slot 0)
            // Both uint128 values are packed in this slot
            let packed := sload(0)
            
            // Extract readMe from the upper 128 bits
            // Right shift by 128 bits to get the upper half
            let result := shr(128, packed)
            
            // Return the unpacked value
            mstore(0x00, result)
            return(0x00, 0x20)
        }
    }
}