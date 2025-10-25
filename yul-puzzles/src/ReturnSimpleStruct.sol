// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract ReturnSimpleStruct {
    // STRUCT
    struct Point {
        uint256 x;
        uint256 y;
    }

    function main(uint256 x, uint256 y) external pure returns (Point memory) {
        assembly {
            // Get free memory pointer
            let ptr := mload(0x40)
            
            // Store struct fields
            mstore(ptr, x)          // x coordinate
            mstore(add(ptr, 0x20), y)  // y coordinate
            
            // Update free memory pointer
            mstore(0x40, add(ptr, 0x40))
            
            // Return the struct (2 * 32 bytes = 64 bytes)
            return(ptr, 0x40)
        }
    }
}
