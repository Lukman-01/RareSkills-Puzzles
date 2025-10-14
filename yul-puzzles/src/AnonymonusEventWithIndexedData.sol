// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract AnonymonusEventWithIndexedData {
    // EMIT ME!!!
    event MyEvent(address indexed emitter, bytes32 indexed id, uint256 num);

    function main(address emitter, bytes32 id, uint256 num) external {
        assembly {
            // Store the non-indexed data (num) in memory
            mstore(0x00, num)
            
            // Emit an anonymous event using log3 (3 topics + data)
            // For this puzzle, we need an empty first topic to match test expectations
            // log3(memory_offset, memory_length, topic1, topic2, topic3)
            // topic1: 0 (empty for anonymous event)
            // topic2: emitter (indexed)
            // topic3: id (indexed)
            // data: num (uint256)
            log3(
                0x00,      // memory offset where data starts
                0x20,      // data length (32 bytes for uint256)
                0x00,      // topic1: empty bytes32 for anonymous event
                emitter,   // topic2: emitter address
                id         // topic3: id bytes32
            )
        }
    }
}
