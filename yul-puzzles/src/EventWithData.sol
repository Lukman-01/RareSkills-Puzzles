// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract EventWithData {
    // EMIT ME!!!
    event MyEvent(uint256 number);

    function main(uint256 _number) external {
        assembly {
            // Calculate keccak256("MyEvent(uint256)")
            // Store the event signature string in memory
            mstore(0x00, "MyEvent(uint256)")
            
            // Calculate the hash of the event signature
            // "MyEvent(uint256)" is 16 bytes long
            let eventHash := keccak256(0x00, 0x10)
            
            // Store the number parameter as data in memory
            // uint256 values are 32 bytes (0x20)
            mstore(0x00, _number)
            
            // Emit the event using log1
            // log1(offset, size, topic0)
            // - offset: 0x00 (where we stored the number data)
            // - size: 0x20 (32 bytes for uint256)
            // - topic0: the event signature hash
            log1(0x00, 0x20, eventHash)
        }
    }
}