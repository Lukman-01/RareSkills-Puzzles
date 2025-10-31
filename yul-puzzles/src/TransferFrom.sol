// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract TransferFrom {
    address owner;
    address token;

    constructor(address _token) {
        owner = msg.sender;
        token = _token;
    }

    function main(uint256 amount) external {
        assembly {
            // Load the token address from storage slot 1
            let tokenAddress := sload(1)
            
            // Load the owner address from storage slot 0
            let ownerAddress := sload(0)
            
            // Prepare the calldata for transferFrom(address,address,uint256)
            // Function selector: 0x23b872dd
            
            // Store function selector (left-shifted to first 4 bytes)
            mstore(0x00, shl(224, 0x23b872dd))
            
            // Store from address (owner) at offset 0x04
            mstore(0x04, ownerAddress)
            
            // Store to address (msg.sender) at offset 0x24
            mstore(0x24, caller())
            
            // Store amount at offset 0x44
            mstore(0x44, amount)
            
            // Make the call
            // call(gas, address, value, argsOffset, argsSize, retOffset, retSize)
            let success := call(
                gas(),          // forward all available gas
                tokenAddress,   // address of the ERC20 token contract
                0,              // no ether sent
                0x00,           // offset of input data
                0x64,           // size of input data (4 + 32 + 32 + 32 = 100 bytes)
                0x00,           // offset where return data will be stored
                0x20            // expected return data size (32 bytes for bool)
            )
            
            // Check if the call was successful
            if iszero(success) {
                revert(0, 0)
            }
        }
    }
}
