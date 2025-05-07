// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract TimelockEscrow {

    address public seller;
    uint256 public constant ESCROW_DURATION = 3 days;

    struct Escrow {
        uint256 amount;
        uint256 startTime;
        bool active;
    }

    mapping(address => Escrow) public escrows;

    /**
     * The goal of this exercise is to create a Time lock escrow.
     * A buyer deposits ether into a contract, and the seller cannot withdraw it until 3 days passes. Before that, the buyer can take it back
     * Assume the owner is the seller
     */

    constructor() {
        seller = msg.sender;
    }

    // creates a buy order between msg.sender and seller
    /**
     * escrows msg.value for 3 days which buyer can withdraw at anytime before 3 days but afterwhich only seller can withdraw
     * should revert if an active escrow still exist or last escrow hasn't been withdrawn
     */
    // Function to create a buy order with escrow
    function createBuyOrder() external payable {
        // Ensure the deposited amount is greater than 0
        require(msg.value > 0, "Your bet must be greater than 0");

        // Ensure no active escrow exists for the caller
        require(!escrows[msg.sender].active, "Active escrow already exists");

        // Create a new escrow entry for the caller
        escrows[msg.sender] = Escrow({
            amount: msg.value,
            startTime: block.timestamp,
            active: true
        });
    }

    // Function for the seller to withdraw after 3 days
    function sellerWithdraw(address buyer) external {
        // Ensure only the seller can withdraw
        require(msg.sender == seller, "Only the seller can withdraw");

        // Retrieve the escrow details for the specified buyer
        Escrow storage escrow = escrows[buyer];

        // Ensure the escrow is active
        require(escrow.active, "No active escrow for this buyer");

        // Ensure the escrow period has ended
        require(block.timestamp >= escrow.startTime + ESCROW_DURATION, "Escrow period has not ended");

        // Transfer the escrowed amount to the seller
        uint256 amount = escrow.amount;
        escrow.amount = 0;
        escrow.active = false;
        payable(seller).transfer(amount);
    }

    // Function for the buyer to withdraw at any time before the end of the escrow period
    function buyerWithdraw() external {
        // Retrieve the escrow details for the caller
        Escrow storage escrow = escrows[msg.sender];

        // Ensure the escrow is active
        require(escrow.active, "No active escrow for this buyer");

        // Ensure the escrow period has not ended
        require(block.timestamp < escrow.startTime + ESCROW_DURATION, "Escrow period has ended");

        // Transfer the escrowed amount to the buyer
        uint256 amount = escrow.amount;
        escrow.amount = 0;
        escrow.active = false;
        payable(msg.sender).transfer(amount);
    }

    // Function to return the escrowed amount for a specified buyer
    function buyerDeposit(address buyer) external view returns (uint256) {
        return escrows[buyer].amount;
    }
}
