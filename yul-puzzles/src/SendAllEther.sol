// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract SendAllEther {

    function main(address payable to) external payable {
        assembly {
            // Get the entire contract balance using selfbalance()
            let bal := selfbalance()
            
            // call(gas, address, value, argsOffset, argsSize, retOffset, retSize)
            // Send all ether to 'to' address
            let success := call(gas(), to, bal, 0, 0, 0, 0)
            
            // Optionally check if call was successful and revert if not
            if iszero(success) {
                revert(0, 0)
            }
        }
    }
}
