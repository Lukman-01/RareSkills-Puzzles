// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract RevertWithPanic {
    function main() external pure {
        assembly {
            // Store the Panic(uint256) selector at position 0x00
            mstore(0x00, 0x4e487b7100000000000000000000000000000000000000000000000000000000)
            
            // Store the panic code 0x01 at position 0x04
            mstore(0x04, 0x01)
            
            // Revert with total length: 4 bytes (selector) + 32 bytes (uint256) = 36 bytes (0x24)
            revert(0x00, 0x24)
        }
    }
}