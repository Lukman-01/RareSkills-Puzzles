// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract AnonymonusEventWithData {
    // EMIT ME!!!
    event MyEvent(uint256 num);

    function main(uint256 num) external {
        assembly {
            // Store the num parameter in memory
            mstore(0x00, num)
            
            // Emit an anonymous event with no topics but with data
            // log0 takes: memory_offset, memory_length
            // We have 32 bytes of data (uint256) starting at memory position 0x00
            log0(0x00, 0x20)
        }
    }
}