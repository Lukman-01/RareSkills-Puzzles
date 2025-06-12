// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract ReadFromStorage {
    uint256 readMe;

    function setValue(uint256 x) external {
        readMe = x;
    }

    function main() external view returns (uint256) {
        assembly {
            // Load the value from storage slot 0
            // readMe is the first state variable, so it's stored at slot 0
            let value := sload(0)
            
            // Store result in memory and return
            mstore(0x00, value)
            return(0x00, 0x20)
        }
    }
}