// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract ReturnBytes {
    function main(address a, uint256 b) external pure returns (bytes memory) {
        assembly {
            // Get free memory pointer
            let ptr := mload(0x40)
            
            // Store the offset to the bytes data (32 bytes ahead)
            mstore(ptr, 0x20)
            
            // Store the length of the encoded data (64 bytes = 2 * 32 bytes)
            mstore(add(ptr, 0x20), 0x40)
            
            // Store address a (32 bytes, padded)
            mstore(add(ptr, 0x40), a)
            
            // Store uint256 b (32 bytes)
            mstore(add(ptr, 0x60), b)
            
            // Update free memory pointer
            mstore(0x40, add(ptr, 0x80))
            
            // Return pointer and total size (0x20 + 0x20 + 0x40 = 0x80)
            return(ptr, 0x80)
        }
    }
}
