// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract ReturnOppositeBool {
    function main(bool _bool) external pure returns (bool) {
        assembly {
            // Load the boolean value from calldata (it's at offset 4 after function selector)
            let b := calldataload(4)
            
            // XOR with 1 to flip the boolean (0 becomes 1, 1 becomes 0)
            let result := xor(b, 1)
            
            // Store result in memory and return
            mstore(0x00, result)
            return(0x00, 0x20)
        }
    }
}
