// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

contract MultiDelegateCall {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        //@audit-issue no acces control, anybody can call this function
        require(amount <= balances[msg.sender], "insufficient balance");
        balances[msg.sender] -= amount;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "withdraw failed");
    }

    function multicall(bytes[] calldata data) external payable {
        //@audit-issue no acces control, anybody can call this function
        bool success;
        //@audit-info use ++i instead of i++
        for (uint256 i = 0; i < data.length; i++) {
            (success, ) = address(this).delegatecall(data[i]);
            //@audit-issue Each delegatecall sees the SAME original msg.value
            require(success, "Call failed");
        }
    }
}
