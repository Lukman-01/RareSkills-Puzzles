// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract CreateSimpleCalldata {
    function main(bytes calldata deploymentBytecode) external returns (address) {
        assembly {
            // Get the length of the bytecode from calldata
            let size := deploymentBytecode.length
            
            // Copy the bytecode from calldata to memory
            // calldatacopy(destOffset, offset, size)
            calldatacopy(0x00, deploymentBytecode.offset, size)
            
            // Use CREATE opcode: create(value, offset, size)
            // value = 0 (no ETH sent with deployment)
            // offset = 0x00 (pointer to bytecode in memory)
            // size = size (length of bytecode)
            let addr := create(0, 0x00, size)
            
            // Store address in memory and return
            mstore(0x00, addr)
            return(0x00, 0x20)
       }
    }
}
