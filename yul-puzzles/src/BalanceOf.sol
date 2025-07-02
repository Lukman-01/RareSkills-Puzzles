// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract BalanceOf {
    function main(address token) external view returns (uint256) {
        assembly {
            // Prepare the function call data
            // Function selector for balanceOf(address) is 0x70a08231
            mstore(0x00, 0x70a08231)
            
            // Shift the function selector to the left by 224 bits (32 - 4 = 28 bytes)
            // to align it properly in the first 4 bytes
            mstore(0x00, shl(224, 0x70a08231))
            
            // Store the address parameter (this contract's address) starting at offset 0x04
            mstore(0x04, address())
            
            // Make the staticcall
            // staticcall(gas, address, argsOffset, argsSize, retOffset, retSize)
            let success := staticcall(
                gas(),      // forward all available gas
                token,      // address of the ERC20 token contract
                0x00,       // offset of input data (function selector + address)
                0x24,       // size of input data (4 bytes selector + 32 bytes address)
                0x00,       // offset where return data will be stored
                0x20        // expected return data size (32 bytes for uint256)
            )
            
            // Check if the call was successful
            if iszero(success) {
                revert(0, 0)
            }
            
            // Copy the return data from the call to memory
            returndatacopy(0x00, 0x00, 0x20)
            
            // Return the balance (32 bytes starting from offset 0x00)
            return(0x00, 0x20)
        }
    }
}