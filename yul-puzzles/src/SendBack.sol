// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract SendBack {

    fallback() external payable {
        assembly {
            // Get the amount of ether sent
            let amount := callvalue()
            
            // Get the sender address
            let sender := caller()
            
            // Send the ether back to the sender
            // call(gas, address, value, argsOffset, argsSize, retOffset, retSize)
            let success := call(gas(), sender, amount, 0, 0, 0, 0)
            
            // Revert if the call failed
            if iszero(success) {
                revert(0, 0)
            }
        }
    }
}
