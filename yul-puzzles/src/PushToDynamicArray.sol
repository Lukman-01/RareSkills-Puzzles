// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract PushToDynamicArray {
    uint256[] pushToMe = [23, 4, 19, 3, 44, 88];

    function main(uint256 newValue) external {
        assembly {
            // Step 1: Load the current array length
            let currentLength := sload(pushToMe.slot)
            
            // Step 2: Calculate the storage slot for the new element
            // Array elements start at keccak256(pushToMe.slot)
            mstore(0x00, pushToMe.slot)
            let dataSlot := keccak256(0x00, 0x20)
            
            // The new element goes at dataSlot + currentLength
            let newElementSlot := add(dataSlot, currentLength)
            
            // Step 3: Store the new value at the calculated slot
            sstore(newElementSlot, newValue)
            
            // Step 4: Increment the array length
            let newLength := add(currentLength, 1)
            sstore(pushToMe.slot, newLength)
        }
    }

    function getter() external view returns (uint256[] memory) {
        return pushToMe;
    }
}