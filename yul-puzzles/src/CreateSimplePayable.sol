// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract CreateSimplePayable {
    function main(uint256 dummy, bytes memory deploymentBytecode) external payable returns (address addr) {
        assembly {
            // Get the length of the bytecode
            let size := mload(deploymentBytecode)
            
            // Get the pointer to the actual bytecode data (skip the length prefix)
            let dataPtr := add(deploymentBytecode, 0x20)
            
            // Get the value sent with this transaction
            let value := callvalue()
            
            // Use CREATE opcode: create(value, offset, size)
            // value = msg.value (ETH sent with deployment)
            // offset = dataPtr (pointer to bytecode in memory)
            // size = size (length of bytecode)
            addr := create(value, dataPtr, size)
        }
    }
}
