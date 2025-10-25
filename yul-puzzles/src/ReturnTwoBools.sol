// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract ReturnTwoBools {
    function main(bool a, bool b) external pure returns (bool, bool) {
        assembly {
            // Load bool a and b from calldata
            // a is at offset 4, b is at offset 36 (4 + 32)
            let valA := calldataload(4)
            let valB := calldataload(36)
            
            // Store both values in memory
            mstore(0x00, valA)
            mstore(0x20, valB)
            
            // Return 64 bytes (2 * 32 bytes)
            return(0x00, 0x40)
        }
    }
}
