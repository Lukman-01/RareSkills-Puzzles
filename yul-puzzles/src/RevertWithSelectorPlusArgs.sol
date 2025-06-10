// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract RevertWithSelectorPlusArgs {
    error RevertData(uint256); // selector: 0xae412287

    function main(uint256 x) external pure {
        assembly {
            // Store the error selector at position 0x00
            mstore(0x00, 0xae41228700000000000000000000000000000000000000000000000000000000)
            
            // Store the parameter x at position 0x04 (right after the 4-byte selector)
            mstore(0x04, x)
            
            // Revert with total length: 4 bytes (selector) + 32 bytes (uint256) = 36 bytes (0x24)
            revert(0x00, 0x24)
        }
    }
}