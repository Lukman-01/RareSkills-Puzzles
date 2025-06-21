// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract AnonymonusEventWithoutData {
    // EMIT ME!!!
    event MyEvent();

    function main() external {
        assembly {
            // Emit an anonymous event with no topics and no data
            // log0 takes: memory_offset, memory_length
            // Since we have no data, both can be 0
            log0(0x00, 0x00)
        }
    }
}