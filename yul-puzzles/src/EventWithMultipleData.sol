// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract EventWithMultipleData {
    // EMIT ME!!!
    event MyEvent(address emitter, uint256 num, bool isActive);

    function main(address emitter, uint256 num, bool isActive) external {
        assembly {
            // Pack the data in memory in the correct order: emitter, num, isActive
            // Each field takes 32 bytes in the ABI encoding
            
            // Store emitter (address) at memory position 0x00
            mstore(0x00, emitter)
            
            // Store num (uint256) at memory position 0x20 (32 bytes offset)
            mstore(0x20, num)
            
            // Store isActive (bool) at memory position 0x40 (64 bytes offset)
            mstore(0x40, isActive)
            
            // Emit the event using log1 (1 topic + data)
            // topic0: keccak256("MyEvent(address,uint256,bool)")
            // data: emitter + num + isActive (96 bytes total: 3 * 32 bytes)
            log1(
                0x00,                                                           // memory offset where data starts
                0x60,                                                           // data length (96 bytes = 3 * 32 bytes)
                0x532e3b2a35ca0879a4b08813e66d07f972db1900da196cbdc7e31d4d1bfc657f   // keccak256("MyEvent(address,uint256,bool)")
            )
        }
    }
}