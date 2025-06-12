// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract ReadFromFixedArray {
    uint256[5] readMe;

    function setValue(uint256[5] calldata x) external {
        readMe = x;
    }

    function main(uint256 index) external view returns (uint256) {
        assembly {
            // Fixed arrays are stored sequentially in storage
            // readMe starts at slot 0, so readMe[i] is at slot (0 + i)
            // Calculate the storage slot for readMe[index]
            let slot := add(0, index)
            
            // Load the value from the calculated storage slot
            let value := sload(slot)
            
            // Store result in memory and return
            mstore(0x00, value)
            return(0x00, 0x20)
        }
    }
}