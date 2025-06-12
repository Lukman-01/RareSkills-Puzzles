// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract LengthOfDynamicArray {
    function main(uint256[] memory x) external view returns (uint256) {
        assembly {
            // In memory, dynamic arrays are stored as:
            // - First 32 bytes: length of the array
            // - Followed by the array elements
            
            // Load the length from the first 32 bytes of the array
            let length := mload(x)
            
            // Store result in memory and return
            mstore(0x00, length)
            return(0x00, 0x20)
        }
    }
}