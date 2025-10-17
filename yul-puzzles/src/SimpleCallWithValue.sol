// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract SimpleCallWithValue {

    function main(address t) external payable {
        assembly {
            // Store the function selector for foo() in memory
            // foo() selector: 0xc2985578
            // Left-shift to place selector at the beginning (first 4 bytes)
            mstore(0x00, shl(224, 0xc2985578))
            
            // Get the value sent with this transaction
            let value := callvalue()
            
            // Call t.foo() with the selector and value
            // call(gas, address, value, argsOffset, argsSize, retOffset, retSize)
            let success := call(gas(), t, value, 0x00, 0x04, 0, 0)
            
            // Optionally handle failure
            if iszero(success) {
                revert(0, 0)
            }
       }
    }
}
