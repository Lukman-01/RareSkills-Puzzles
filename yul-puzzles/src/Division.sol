// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract Division {

    function main(int256 x, int256 y) external pure returns (int256) {
        assembly {
            // Check if y == 0, if so revert
            if iszero(y) {
                revert(0, 0)
            }
            
            // Perform signed division
            let result := sdiv(x, y)
            
            // Store result in memory and return
            mstore(0x00, result)
            return(0x00, 0x20)
        }
    }
}
