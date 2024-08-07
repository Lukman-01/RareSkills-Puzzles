// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract Withdraw {
    // @notice make this contract able to receive ether from anyone and anyone can call withdraw below to withdraw all ether from it
    // Function to withdraw all ether from the contract
    function withdraw() public {
        // Transfer all ether to the caller
        payable(msg.sender).transfer(address(this).balance);
    }

    // Function to receive ether from anyone
    receive() external payable {}
}
