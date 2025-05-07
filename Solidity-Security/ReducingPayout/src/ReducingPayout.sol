// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract ReducingPayout {
    /*
        This exercise assumes you know how block.timestamp works.
        1. This contract has 1 ether in it, each second that goes by, 
           the amount that can be withdrawn by the caller goes from 100% to 0% as 24 hours passes.
        2. Implement your logic in `withdraw` function.
        Hint: 1 second deducts 0.0011574% from the current %.
    */

    // The time 1 ether was sent to this contract
    uint256 public immutable depositedTime;

    constructor() payable {
        require(msg.value == 1 ether, "Contract must be initialized with exactly 1 ether");
        depositedTime = block.timestamp;
    }

    function withdraw() public {
        uint256 elapsedTime = block.timestamp - depositedTime;
        require(elapsedTime <= 24 hours, "Withdrawal period has ended");

        // Calculate the percentage of ether that can be withdrawn
        uint256 percentage = 100 - ((elapsedTime * 100) / 1 days);

        // Calculate the withdrawable amount
        uint256 withdrawableAmount = (address(this).balance * percentage) / 100;

        // Transfer the withdrawable amount to the caller
        payable(msg.sender).transfer(withdrawableAmount);
    }
}
