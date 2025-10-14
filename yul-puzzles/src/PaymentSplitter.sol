// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract PaymentSplitter {

    function main(address[] calldata recipients) external payable {
        assembly {
            // Get the number of recipients
            let numRecipients := recipients.length
            
            // Get the contract's balance
            let bal := selfbalance()
            
            // Calculate amount per recipient
            let amountPerRecipient := div(bal, numRecipients)
            
            // Loop through all recipients and send them their share
            for { let i := 0 } lt(i, numRecipients) { i := add(i, 1) } {
                // Calculate the offset to get recipients[i]
                // calldata layout: recipients.offset + i * 32
                let recipient := calldataload(add(recipients.offset, mul(i, 0x20)))
                
                // Send ether to the recipient
                // call(gas, address, value, argsOffset, argsSize, retOffset, retSize)
                let success := call(gas(), recipient, amountPerRecipient, 0, 0, 0, 0)
                
                // Revert if the call failed
                if iszero(success) {
                    revert(0, 0)
                }
            }
        }
    }
}
