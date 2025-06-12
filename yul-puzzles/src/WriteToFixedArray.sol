// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract WriteToFixedArray {
    uint256[5] writeHere;

    function main(uint256[5] memory x) external {
        assembly {
            // Fixed arrays in storage are stored sequentially starting from slot 0
            // writeHere[0] is at slot 0, writeHere[1] is at slot 1, etc.
            
            // Loop through all 5 elements of the array
            let i := 0
            for { } lt(i, 5) { i := add(i, 1) } {
                // Calculate memory offset for x[i]
                // Memory layout: x points to start, each element is 32 bytes
                let memOffset := add(x, mul(i, 0x20))
                
                // Load value from memory array x[i]
                let value := mload(memOffset)
                
                // Store value in storage slot i (writeHere[i])
                sstore(i, value)
            }
        }
    }

    function getter() external view returns (uint256[5] memory) {
        return writeHere;
    }
}