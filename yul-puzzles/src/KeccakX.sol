// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract keccakX {
    function main(uint256 x) external pure returns (bytes32) {
        assembly {
            // Store x in memory at position 0x00
            mstore(0x00, x)
            
            // Compute keccak256 hash of the 32 bytes starting at position 0x00
            let hash := keccak256(0x00, 0x20)
            
            // Store the hash result in memory and return
            mstore(0x00, hash)
            return(0x00, 0x20)
        }
    }
}