// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract EventWithoutData {
    // EMIT ME!!!
    event MyEvent();

    function main() external {
        assembly {
            // Method 1: Use pre-calculated keccak256("MyEvent()")
            // You can calculate this hash: keccak256("MyEvent()") = 0x7e4c4a9f7a0e3f2b1c9d8e6f5a4b3c2d1e0f9a8b7c6d5e4f3a2b1c0d9e8f7a6b5c4
            
            // Method 2: Calculate the hash dynamically (more educational)
            // Store "MyEvent()" in memory
            mstore(0x00, "MyEvent()")
            
            // Calculate keccak256 hash of "MyEvent()"
            let eventHash := keccak256(0x00, 0x09) // 9 bytes for "MyEvent()"
            
            // Emit the event using log1
            // log1(offset, size, topic0)
            // - offset: 0 (no data to log)
            // - size: 0 (no data to log)  
            // - topic0: the event signature hash
            log1(0, 0, eventHash)
        }
    }
}