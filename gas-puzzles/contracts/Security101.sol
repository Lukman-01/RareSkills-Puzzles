// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.15;

contract OptimizedSecurity101 {
    mapping(address => uint256) balances;

    error LowBalance(string message);
    error FailedTransaction(string message);

    // Use receive function to handle direct ether transfers
    receive() external payable {
        balances[msg.sender] += msg.value;
    }

    /*
    // Original function to be optimized
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, 'insufficient funds');
        (bool ok, ) = msg.sender.call{value: amount}('');
        require(ok, 'transfer failed');
        unchecked {
            balances[msg.sender] -= amount;
        }
    }
    */

    // Optimized function
    function withdraw(uint256 amount) external {
        if (balances[msg.sender] < amount) {
            revert LowBalance("insufficient funds");
        }

        (bool ok, ) = msg.sender.call{value: amount}('');
        if (!ok) {
            revert FailedTransaction("transfer failed");
        }

        unchecked {
            balances[msg.sender] -= amount;
        }
    }

    /*
    Optimizations:
    1. Custom Errors: Replaced `require` statements with custom errors to save gas.
       - `LowBalance`: Custom error for insufficient funds.
       - `FailedTransaction`: Custom error for failed ether transfer.
    2. If Statements: Used `if` statements instead of `require` for condition checks and reverting with custom errors.
       - This avoids the overhead of `require` and makes the code more gas-efficient.
    3. Receive Function: Added a receive function to handle direct ether transfers, making the deposit function more efficient.
    */
}
