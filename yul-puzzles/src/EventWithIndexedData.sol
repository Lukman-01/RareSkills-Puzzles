// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract EventWithIndexedData {
    // EMIT ME!!!
    event MyEvent(address indexed emitter, bytes32 indexed id, uint256 num);

    function main(address emitter, bytes32 id, uint256 num) external {
        assembly {
            // Store the non-indexed data (num) in memory
            mstore(0x00, num)
            
            // Emit the event using log3 (3 topics + data)
            // topic0: keccak256("MyEvent(address,bytes32,uint256)")
            // topic1: emitter address  
            // topic2: id bytes32
            // data: num (32 bytes at memory position 0x00)
            log3(
                0x00,                                                           // memory offset where data starts
                0x20,                                                           // data length (32 bytes for uint256)
                0x044d482819499c9d5fde1245ce63873b1259fc52fc78651ccdcdf7392637d374,     // keccak256("MyEvent(address,bytes32,uint256)")
                emitter,                                                        // topic1: emitter address
                id                                                              // topic2: id bytes32
            )
        }
    }
}