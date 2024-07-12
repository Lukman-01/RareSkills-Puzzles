// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract IdiotBettingGame {
    /*
        This exercise assumes you know how block.timestamp works.
        - Whoever deposits the most ether into a contract wins all the ether if no-one 
          else deposits after an hour.
        1. `bet` function allows users to deposit ether into the contract. 
           If the deposit is higher than the previous highest deposit, the endTime is 
           updated by current time + 1 hour, the highest deposit and winner are updated.
        2. `claimPrize` function can only be called by the winner after the betting 
           period has ended. It transfers the entire balance of the contract to the winner.
    */

    address public highestBidder;
    uint256 public highestBet;
    uint256 public endTime;

    function bet() public payable {
        require(msg.value > 0, "Your bet must be greater than 0");

        if (msg.value > highestBet) {
            highestBidder = msg.sender;
            highestBet = msg.value;
            endTime = block.timestamp + 1 hours;
        }
    }

    function claimPrize() public {
        require(block.timestamp > endTime, "Betting period has not ended yet");
        require(msg.sender == highestBidder, "Only the highest bidder can claim the prize");

        uint256 prizeAmount = address(this).balance;
        payable(highestBidder).transfer(prizeAmount);

        // Reset the game
        highestBidder = address(0);
        highestBet = 0;
        endTime = 0;
    }
}
