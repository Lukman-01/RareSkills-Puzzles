// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract WriteToDoubleMapping {
    mapping(address user => mapping(address token => uint256 value)) public balances;

    function main(address user, address token, uint256 value) external {
        assembly {
            // Store the slot number of the balances mapping (slot 0)
            let balancesSlot := 0
            
            // Compute the slot for balances[user]
            // This is keccak256(abi.encode(user, balancesSlot))
            mstore(0x00, user)
            mstore(0x20, balancesSlot)
            let userMappingSlot := keccak256(0x00, 0x40)
            
            // Compute the slot for balances[user][token]
            // This is keccak256(abi.encode(token, userMappingSlot))
            mstore(0x00, token)
            mstore(0x20, userMappingSlot)
            let finalSlot := keccak256(0x00, 0x40)
            
            // Store the value at the computed slot
            sstore(finalSlot, value)
        }
    }
}