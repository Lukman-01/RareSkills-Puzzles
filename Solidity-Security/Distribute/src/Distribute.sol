// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract Distribute {
    /*
        This exercise assumes you know how to send Ether.
        1. This contract has some ether in it, distribute it equally among the
           array of addresses that is passed as an argument.
        2. Write your code in the `distributeEther` function.
    */

    constructor() payable {}

    function distributeEther(address[] memory addresses) public {
        require(addresses.length > 0, "No addresses provided");

        uint256 totalAmount = address(this).balance;
        uint256 amountForEach = totalAmount / addresses.length;

        for (uint256 i = 0; i < addresses.length; i++) {
            payable(addresses[i]).transfer(amountForEach);
        }

        // Transfer any remaining balance back to the sender to avoid any leftover ether
        uint256 remainingBalance = address(this).balance;
        if (remainingBalance > 0) {
            payable(msg.sender).transfer(remainingBalance);
        }
    }
}
