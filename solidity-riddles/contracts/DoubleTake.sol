// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

// You've been approved to claim 1 ETH. Claim more than your fair share.
contract DoubleTake {
    address signer = 0x5Cd705F118aD9357Ac8330f48AdA7A60F3efc200;
    mapping(bytes => bool) used;
    mapping(address => uint256) public allowance;

    constructor() payable {}

    function claimAirdrop(address user, uint256 amount, uint8 v, bytes32 r, bytes32 s) external {
        bytes32 hash_ = keccak256(abi.encode(user, amount));
        bytes memory signature = abi.encodePacked(v, r, s);

        require(signer == ecrecover(hash_, v, r, s), "signature not accepted");
        //@audit-issue Can replay signature with modified (s, v) pair, the catch below is not enough to prevent replay
        require(!used[signature], "signature already used");
        //@audit-issue suppose set signature to used before transfer, then the contract will be drained
        used[signature] = true;

        (bool ok, ) = user.call{value: amount}("");
        require(ok, "transfer failed");
    }
}
