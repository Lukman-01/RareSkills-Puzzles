// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract BatchEvents {
    // EMIT ME!!!
    event MyEvent(address indexed emitter, bytes32 indexed id, uint256 num);

    function main(address[] memory emitters, bytes32[] memory ids, uint256[] memory nums) external {
        assembly {
            // Get the length of the emitters array (assuming all arrays have equal length)
            let length := mload(emitters)
            
            // Calculate the event signature hash for MyEvent(address,bytes32,uint256)
            // keccak256("MyEvent(address,bytes32,uint256)")
            let eventSig := 0x044d482819499c9d5fde1245ce63873b1259fc52fc78651ccdcdf7392637d374
            
            // Initialize loop counter
            let i := 0
            
            // Loop through all array elements
            for { } lt(i, length) { i := add(i, 1) } {
                // Calculate offset for current element (32 bytes per element + 32 bytes for length)
                let offset := add(0x20, mul(i, 0x20))
                
                // Load values from arrays
                let emitter := mload(add(emitters, offset))
                let id := mload(add(ids, offset))
                let num := mload(add(nums, offset))
                
                // Emit the event with indexed parameters
                // log3(dataOffset, dataSize, topic0, topic1, topic2)
                // topic0 = event signature
                // topic1 = indexed emitter (address)
                // topic2 = indexed id (bytes32)
                // data = num (uint256)
                
                // Store the non-indexed data (num) in memory
                mstore(0x00, num)
                
                // Emit the event
                log3(0x00, 0x20, eventSig, emitter, id)
            }
        }
    }
}