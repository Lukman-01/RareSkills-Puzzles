// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract DistributeV2 {
    /*
        This exercise assumes you know how to send Ether.
        1. This contract has some ether in it, distribute it equally among the
           array of addresses that is passed as an argument.
        2. Write your code in the `distributeEther` function.
        3. Consider scenarios where one of the recipients rejects the ether transfer, 
           have a workaround for that whereby other recipients still get their transfer.
    */

    constructor() payable {}

    function distributeEther(address[] memory addresses) public {
        require(addresses.length > 0, "No address passed");

        uint256 totalAmount = address(this).balance;
        uint256 amountForEach = totalAmount / addresses.length;

        for (uint256 i = 0; i < addresses.length; i++) {
            (bool success, ) = payable(addresses[i]).call{value: amountForEach}("");
            if (!success) {
                // Handle the failure: log the failure or store the failed addresses
                emit TransferFailed(addresses[i], amountForEach);
            }
        }

        // If there's any remaining balance due to division rounding, refund it to the sender
        uint256 remainingBalance = address(this).balance;
        if (remainingBalance > 0) {
            payable(msg.sender).transfer(remainingBalance);
        }
    }

    event TransferFailed(address indexed recipient, uint256 amount);
}
