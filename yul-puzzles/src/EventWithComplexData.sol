// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract EventWithComplexData {
    // EMIT ME!!!
    event MyEvent(address indexed emitter, address[] players, uint256[] scores);

    function main(address emitter, address[] memory players, uint256[] memory scores) external {
        assembly {
            // Calculate event signature: keccak256("MyEvent(address,address[],uint256[])")
            let eventSig := 0x4e9c58eb8e44c7b06af58fa8c2efea9c46e5f6c4e3bc4f94e2f78b3f7f8a5e2b
            
            // Get free memory pointer
            let freePtr := mload(0x40)
            
            // Encode the data payload
            // ABI encoding for (address[], uint256[]):
            // - offset to players array (0x40 = 64 bytes)
            // - offset to scores array (calculate based on players array size)
            // - players array data (length + elements)
            // - scores array data (length + elements)
            
            // Get array lengths
            let playersLen := mload(players)
            let scoresLen := mload(scores)
            
            // Calculate offset to scores array
            // offset = 0x40 (for two offsets) + 0x20 (players length) + playersLen * 0x20
            let scoresOffset := add(0x40, add(0x20, mul(playersLen, 0x20)))
            
            // Store offsets
            mstore(freePtr, 0x40)                    // offset to players array
            mstore(add(freePtr, 0x20), scoresOffset)  // offset to scores array
            
            // Store players array (length + data)
            mstore(add(freePtr, 0x40), playersLen)
            for { let i := 0 } lt(i, playersLen) { i := add(i, 1) } {
                let player := mload(add(add(players, 0x20), mul(i, 0x20)))
                mstore(add(add(freePtr, 0x60), mul(i, 0x20)), player)
            }
            
            // Store scores array (length + data)
            let scoresStart := add(freePtr, scoresOffset)
            mstore(scoresStart, scoresLen)
            for { let i := 0 } lt(i, scoresLen) { i := add(i, 1) } {
                let score := mload(add(add(scores, 0x20), mul(i, 0x20)))
                mstore(add(scoresStart, add(0x20, mul(i, 0x20))), score)
            }
            
            // Calculate total data size
            let totalSize := add(scoresOffset, add(0x20, mul(scoresLen, 0x20)))
            
            // Emit the event with log2 (1 indexed parameter + data)
            log2(freePtr, totalSize, eventSig, emitter)
        }
    }
}
