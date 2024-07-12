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
    function createBuyOrder() external payable {
        // your code here
        require(msg.value > 0, "Your bet must be greater than 0");
        require(!escrows[msg.sender].active, "Active escrow already exists");

        escrows[msg.sender] = Escrow({
            amount: msg.value,
            startTime: block.timestamp,
            active: true
        });

    }

    /**
     * allows seller to withdraw after 3 days of the escrow with @param buyer has passed
     */
    function sellerWithdraw(address buyer) external {
        // your code here
        require(msg.sender == seller, "Only the seller can withdraw");
        Escrow storage escrow = escrows[buyer];
        require(escrow.active, "No active escrow for this buyer");
        require(block.timestamp >= escrow.startTime + ESCROW_DURATION, "Escrow period has not ended");

        uint256 amount = escrow.amount;
        escrow.amount = 0;
        escrow.active = false;
        payable(seller).transfer(amount);
    }

    /**
     * allowa buyer to withdraw at anytime before the end of the escrow (3 days)
     */
    function buyerWithdraw() external {
        // your code here
        Escrow storage escrow = escrows[msg.sender];
        require(escrow.active, "No active escrow for this buyer");
        require(block.timestamp < escrow.startTime + ESCROW_DURATION, "Escrow period has ended");

        uint256 amount = escrow.amount;
        escrow.amount = 0;
        escrow.active = false;
        payable(msg.sender).transfer(amount);
    }

    // returns the escrowed amount of @param buyer
    function buyerDeposit(address buyer) external view returns (uint256) {
        // your code here
        return escrows[buyer].amount;
    }
}
