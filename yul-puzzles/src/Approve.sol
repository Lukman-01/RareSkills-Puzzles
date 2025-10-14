// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract Approve {
    // emit these
    function main(address token, uint256 amount) external {
        assembly {
            // Prepare the calldata for approve(address,uint256)
            // Function selector: 0x095ea7b3
            
            // Store function selector (left-shifted to first 4 bytes)
            mstore(0x00, shl(224, 0x095ea7b3))
            
            // Store spender address (token) at offset 0x04
            mstore(0x04, token)
            
            // Store amount at offset 0x24 (36 bytes from start)
            mstore(0x24, amount)
            
            // Make the call
            // call(gas, address, value, argsOffset, argsSize, retOffset, retSize)
            let success := call(
                gas(),      // forward all available gas
                token,      // address of the ERC20 token contract
                0,          // no ether sent
                0x00,       // offset of input data
                0x44,       // size of input data (4 bytes selector + 32 bytes address + 32 bytes amount = 68 bytes)
                0x00,       // offset where return data will be stored
                0x20        // expected return data size (32 bytes for bool)
            )
            
            // Check if the call was successful
            if iszero(success) {
                revert(0, 0)
            }
       }
    }
}
