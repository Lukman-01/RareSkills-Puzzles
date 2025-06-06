// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract Wallet {
    address public immutable forwarder;

    constructor(address _forwarder) payable {
        require(msg.value == 1 ether);
        forwarder = _forwarder;
    }

    function sendEther(address destination, uint256 amount) public {
        //@audit-issue Any user can bypass this by calling through the Forwarder contract. Verify the original tx.sender
        require(msg.sender == forwarder, "sender must be forwarder contract");
        (bool success, ) = destination.call{value: amount}("");
        require(success, "failed");
    }
}

contract Forwarder {
    function functionCall(address a, bytes calldata data) public {
        //@audit-issue lack of access control
        (bool success, ) = a.call(data);
        require(success, "forward failed");
    }
}
