// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract ReturnArrayOfUint256 {
    function main(uint256 a, uint256 b, uint256 c) external pure returns (uint256[] memory) {
        assembly {
            // Get free memory pointer
            let ptr := mload(0x40)
            
            // Store the offset to array data (0x20)
            mstore(ptr, 0x20)
            
            // Store array length (3)
            mstore(add(ptr, 0x20), 3)
            
            // Store array elements
            mstore(add(ptr, 0x40), a)
            mstore(add(ptr, 0x60), b)
            mstore(add(ptr, 0x80), c)
            
            // Update free memory pointer
            mstore(0x40, add(ptr, 0xa0))
            
            // Return: offset(32) + length(32) + 3*elements(96) = 160 bytes (0xa0)
            return(ptr, 0xa0)
        }
    }
}
