// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

contract Staking {
    struct Stake {
        uint256 amount;
        address buyer;
        uint256 depositTimestamp;
        uint256 duration;
    }

    mapping(address => Stake) public stakes;

    // Custom errors
    error InvalidDuration();
    error NoStakeFound();
    error StakingPeriodNotOver();
    error EtherTransferFailed();

    // Function to stake Ether with a specified duration
    function stakeEther(uint256 duration) external payable {
        // Check for valid durations
        if (duration != 1 days && duration != 7 days && duration != 30 days) {
            revert InvalidDuration();
        }

        // Store the user's stake in the stakes mapping
        unchecked {
            stakes[msg.sender] = Stake({
                amount: msg.value,
                buyer: msg.sender,
                depositTimestamp: block.timestamp,
                duration: duration
            });
        }
    }

    // Function to withdraw staked Ether after the lock period
    function withdrawEther() external {
        Stake storage userStake = stakes[msg.sender];

        // Ensure the user has a stake
        if (userStake.amount == 0) {
            revert NoStakeFound();
        }

        // Ensure the staking period has ended
        if (block.timestamp < userStake.depositTimestamp + userStake.duration) {
            revert StakingPeriodNotOver();
        }

        uint256 amount = userStake.amount;

        // Delete the user's stake from storage to save gas
        delete stakes[msg.sender];

        // Transfer the staked Ether back to the user
        (bool success, ) = msg.sender.call{value: amount}("");
        if (!success) {
            revert EtherTransferFailed();
        }
    }
}
