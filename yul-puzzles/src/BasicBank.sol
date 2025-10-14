// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract BasicBank {
    // emit these
    event Deposit(address indexed depositor, uint256 amount);
    event Withdraw(address indexed withdrawer, uint256 amount);

    error InsufficientBalance();

    mapping(address => uint256) public balances;

    function deposit() external payable {
        bytes32 depositSelector = Deposit.selector;
        assembly {
            // Get msg.sender and msg.value
            let sender := caller()
            let value := callvalue()
            
            // Calculate storage slot for balances[msg.sender]
            mstore(0x00, sender)
            mstore(0x20, balances.slot)
            let slot := keccak256(0x00, 0x40)
            
            // Load current balance
            let currentBalance := sload(slot)
            
            // Increment balance
            let newBalance := add(currentBalance, value)
            sstore(slot, newBalance)
            
            // Emit Deposit event
            // Deposit(address indexed depositor, uint256 amount)
            // log2: topic0 = event signature, topic1 = indexed depositor
            mstore(0x00, value)
            log2(0x00, 0x20, depositSelector, sender)
        }
    }

    function withdraw(uint256 amount) external returns (uint256 bal) {
        bytes32 withdrawSelector = Withdraw.selector;
        bytes32 errorSelector = bytes32(InsufficientBalance.selector);
        assembly {
            // Get msg.sender
            let sender := caller()
            
            // Calculate storage slot for balances[msg.sender]
            mstore(0x00, sender)
            mstore(0x20, balances.slot)
            let slot := keccak256(0x00, 0x40)
            
            // Load current balance
            let currentBalance := sload(slot)
            
            // Check if balance is sufficient
            if lt(currentBalance, amount) {
                // Revert with InsufficientBalance()
                // The error selector is already padded to the left in the bytes32
                mstore(0x00, errorSelector)
                revert(0x00, 0x04)
            }
            
            // Decrement balance
            let newBalance := sub(currentBalance, amount)
            sstore(slot, newBalance)
            
            // Emit Withdraw event
            // Withdraw(address indexed withdrawer, uint256 amount)
            mstore(0x00, amount)
            log2(0x00, 0x20, withdrawSelector, sender)
            
            // Send amount to msg.sender
            let success := call(gas(), sender, amount, 0, 0, 0, 0)
            
            if iszero(success) {
                revert(0, 0)
            }
            
            // Return the new balance
            bal := newBalance
        }
    }
}
