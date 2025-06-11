// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract CalldataLength {
    function main(bytes calldata) external pure returns (uint256) {
        assembly {
            // Get the total size of calldata
            let size := calldatasize()
            
            // Store result in memory and return
            mstore(0x00, size)
            return(0x00, 0x20)
        }
    }
}