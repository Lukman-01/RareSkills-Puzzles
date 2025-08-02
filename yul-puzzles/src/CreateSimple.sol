// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract CreateSimple {
    function main(bytes memory deploymentBytecode) external returns (address addr) {
        assembly {
            // Get the length of the bytecode
            let size := mload(deploymentBytecode)
            
            // Get the pointer to the actual bytecode data (skip the length prefix)
            let dataPtr := add(deploymentBytecode, 0x20)
            
            // Use CREATE opcode: create(value, offset, size)
            // value = 0 (no ETH sent with deployment)
            // offset = dataPtr (pointer to bytecode in memory)
            // size = size (length of bytecode)
            addr := create(0, dataPtr, size)
        }
    }
}