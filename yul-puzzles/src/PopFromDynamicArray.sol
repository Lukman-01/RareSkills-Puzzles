// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract PopFromDynamicArray {
    uint256[] popFromMe = [23, 4, 19, 3, 44, 88];

    function main() external {
        assembly {
            // Step 1: Load the current array length
            let currentLength := sload(popFromMe.slot)
            
            // Step 2: Calculate the storage slot for the last element
            // Array elements start at keccak256(popFromMe.slot)
            mstore(0x00, popFromMe.slot)
            let dataSlot := keccak256(0x00, 0x20)
            
            // The last element is at dataSlot + (currentLength - 1)
            let lastElementSlot := add(dataSlot, sub(currentLength, 1))
            
            // Step 3: Clear the last element's storage slot
            sstore(lastElementSlot, 0)
            
            // Step 4: Decrement the array length
            let newLength := sub(currentLength, 1)
            sstore(popFromMe.slot, newLength)
        }
    }

    function getter() external view returns (uint256[] memory) {
        return popFromMe;
    }

    function lastElementSlotValue(bytes32 s) external view returns (uint256 r) {
        assembly {
            r := sload(s)
        }
    }
}