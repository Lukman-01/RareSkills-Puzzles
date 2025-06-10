// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract RevertWithError {
    function main() external pure {
        assembly {
            // Store Error(string) selector at 0x00
            mstore(0x00, 0x08c379a000000000000000000000000000000000000000000000000000000000)
            
            // Store offset to string data (0x20 = 32 bytes from start)
            mstore(0x04, 0x20)
            
            // Store string length (12 bytes for "RevertRevert")
            mstore(0x24, 0x0c)
            
            // Store the string "RevertRevert" (12 bytes)
            mstore(0x44, "RevertRevert")
            
            // Revert with total length: 4 + 32 + 32 + 32 = 100 bytes (0x64)
            revert(0x00, 0x64)
        }
    }
}