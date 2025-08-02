// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract DeployNBytes {
    function main(uint256 size) external returns (address) {
        assembly {
            // Start writing init code at memory position 0
            let memPtr := 0
            
            // We need to create init code that returns 'size' bytes
            // The init code structure:
            // 1. Push the size onto stack
            // 2. Push 0 (offset) onto stack  
            // 3. RETURN opcode
            
            // Store the runtime code (just zeros) starting after init code
            // We'll put runtime code at offset that comes after our init code
            let runtimeOffset := 0x20 // Start runtime code at offset 32
            
            // Fill the runtime code area with zeros (or any bytes)
            for { let i := 0 } lt(i, size) { i := add(i, 1) } {
                mstore8(add(runtimeOffset, i), 0x00)
            }
            
            // Now create the init code that will return this runtime code
            // PUSH2 size (3 bytes: 0x61 + 2 bytes for size)
            mstore8(memPtr, 0x61) // PUSH2 opcode
            mstore8(add(memPtr, 1), shr(8, size)) // high byte of size
            mstore8(add(memPtr, 2), size) // low byte of size
            
            // PUSH1 runtimeOffset (2 bytes: 0x60 + 1 byte for offset)
            mstore8(add(memPtr, 3), 0x60) // PUSH1 opcode
            mstore8(add(memPtr, 4), runtimeOffset) // runtime offset
            
            // RETURN (1 byte: 0xf3)
            mstore8(add(memPtr, 5), 0xf3) // RETURN opcode
            
            // Total init code length is 6 bytes
            let initCodeSize := 6
            
            // Deploy the contract using CREATE
            let addr := create(0, memPtr, add(initCodeSize, size))
            
            // Return the deployed contract address
            mstore(0, addr)
            return(0, 0x20)
        }
    }
}