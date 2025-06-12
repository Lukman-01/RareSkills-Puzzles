// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract WriteToStorage {
    uint256 public writeHere;

    function main(uint256 x) external {
        assembly {
            // Store the value x in storage slot 0
            // writeHere is the first state variable, so it's stored at slot 0
            sstore(0, x)
        }
    }
}