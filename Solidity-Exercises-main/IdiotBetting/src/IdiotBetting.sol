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

        // Address of the highest bidder
    address public highestBidder;
    
    // Amount of the highest bet
    uint256 public highestBet;
    
    // End time of the betting period
    uint256 public endTime;

    // Function to place a bet
    function bet() public payable {
        // Require that the bet amount is greater than 0
        require(msg.value > 0, "Your bet must be greater than 0");

        // If the new bet is higher than the current highest bet
        if (msg.value > highestBet) {
            // Update the highest bidder to the current sender
            highestBidder = msg.sender;
            
            // Update the highest bet to the new bet amount
            highestBet = msg.value;
            
            // Set the end time of the betting period to 1 hour from now
            endTime = block.timestamp + 1 hours;
        }
    }

    // Function to claim the prize
    function claimPrize() public {
        // Require that the current time is after the end time of the betting period
        require(block.timestamp > endTime, "Betting period has not ended yet");
        
        // Require that the caller is the highest bidder
        require(msg.sender == highestBidder, "Only the highest bidder can claim the prize");

        // Calculate the prize amount as the current contract balance
        uint256 prizeAmount = address(this).balance;
        
        // Transfer the prize amount to the highest bidder
        payable(highestBidder).transfer(prizeAmount);

        // Reset the game by clearing the highest bidder, highest bet, and end time
        highestBidder = address(0);
        highestBet = 0;
        endTime = 0;
    }
}
