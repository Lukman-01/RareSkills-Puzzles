// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract SimpleCall {

    function main(address t) external payable {
        assembly {
            // Store the function selector for foo() in memory
            // foo() selector: 0xc2985578
            mstore(0x00, 0xc2985578)
            
            // Prepare the calldata by left-shifting to place selector at the beginning
            mstore(0x00, shl(224, 0xc2985578))
            
            // Call t.foo() with the selector
            // call(gas, address, value, argsOffset, argsSize, retOffset, retSize)
            let success := call(gas(), t, 0, 0x00, 0x04, 0, 0)
            
            // Optionally handle failure
            if iszero(success) {
                revert(0, 0)
            }
       }
    }
}
