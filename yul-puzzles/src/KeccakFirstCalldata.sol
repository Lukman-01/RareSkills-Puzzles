// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract KeccakFirstCalldata {
    function main(uint256, uint256, uint256) external pure returns (bytes32) {
        assembly {
            // Calldata layout:
            // 0x00-0x03: function selector (4 bytes)
            // 0x04-0x23: first uint256 argument (32 bytes)
            // 0x24-0x43: second uint256 argument (32 bytes)
            // 0x44-0x63: third uint256 argument (32 bytes)
            
            // Copy the first argument from calldata to memory
            // calldatacopy(destOffset, dataOffset, size)
            calldatacopy(0x00, 0x04, 0x20)
            
            // Compute keccak256 hash of the 32 bytes in memory
            let hash := keccak256(0x00, 0x20)
            
            // Store the hash result in memory and return
            mstore(0x00, hash)
            return(0x00, 0x20)
        }
    }
}