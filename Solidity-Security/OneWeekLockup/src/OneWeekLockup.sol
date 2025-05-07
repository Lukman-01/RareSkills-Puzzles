// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract OneWeekLockup {
    /**
     * In this exercise you are expected to create functions that let users deposit ether
     * Users can also withdraw their ether (not more than their deposit) but should only be able to do a week after their last deposit
     * Consider edge cases by which users might utilize to deposit ether
     *
     * Required function
     * - depositEther()
     * - withdrawEther(uint256 )
     * - balanceOf(address )
     */

    struct UserInfo {
        uint256 balance;
        uint256 lastDepositTime;
    }

    mapping(address => UserInfo) private userBalances;

    /**
     * @notice Returns the balance of a user in the contract.
     * @param user The address of the user.
     * @return The balance of the user in the contract.
     */
    function balanceOf(address user) public view returns (uint256) {
        return userBalances[user].balance;
    }

    /**
     * @notice Deposit ether into the contract.
     */
    function depositEther() external payable {
        require(msg.value > 0, "Must send ether to deposit");
        userBalances[msg.sender].balance += msg.value;
        userBalances[msg.sender].lastDepositTime = block.timestamp;
    }

    /**
     * @notice Withdraw ether from the contract.
     * @param amount The amount of ether to withdraw.
     */
    function withdrawEther(uint256 amount) external {
        require(block.timestamp >= userBalances[msg.sender].lastDepositTime + 1 weeks, "Cannot withdraw within a week of the last deposit");
        require(amount <= userBalances[msg.sender].balance, "Insufficient balance");

        userBalances[msg.sender].balance -= amount;
        payable(msg.sender).transfer(amount);
    }
}
