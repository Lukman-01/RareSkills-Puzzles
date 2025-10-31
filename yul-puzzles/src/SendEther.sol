// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract SendEther {

    function main(address payable to, uint256 amount) external payable {
        assembly {
            // call(gas, address, value, argsOffset, argsSize, retOffset, retSize)
            // Send amount of ether to 'to' address
            // We don't need to send any calldata, so argsOffset and argsSize are 0
            // We don't expect any return data, so retOffset and retSize are 0
            let success := call(gas(), to, amount, 0, 0, 0, 0)
            
            // Optionally check if call was successful and revert if not
            if iszero(success) {
                revert(0, 0)
            }
        }
    }
}
