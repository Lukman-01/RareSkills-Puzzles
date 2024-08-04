// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.15;

contract OptimizedVote {
    struct Voter {
        bool voted;
        uint8 vote;
    }

    struct Proposal {
        bytes32 name;
        uint8 voteCount;
        bool ended;
    }

    mapping(address => Voter) public voters;
    Proposal[] public proposals;

    // Custom errors for better gas efficiency
    error AlreadyVoted();
    error InvalidProposal();

    function createProposal(bytes32 _name) external {
        proposals.push(Proposal({name: _name, voteCount: 0, ended: false}));
    }

    function vote(uint8 _proposal) external {
        Voter storage sender = voters[msg.sender];
        if (sender.voted) {
            revert AlreadyVoted();
        }
        if (_proposal >= proposals.length) {
            revert InvalidProposal();
        }

        // Use a single storage write operation for the voter information
        sender.vote = _proposal;
        sender.voted = true;

        // Increment the vote count of the selected proposal
        Proposal storage proposal = proposals[_proposal];
        proposal.voteCount += 1;
    }

    function getVoteCount(uint8 _proposal) external view returns (uint8) {
        return proposals[_proposal].voteCount;
    }
}

/*
Explanation:
- Custom Errors: Using custom errors (`AlreadyVoted` and `InvalidProposal`) to save gas instead of string-based `require` statements.
- Storage Pointer: Using a storage pointer (`Voter storage sender = voters[msg.sender];`) to reduce frequent writes to storage and improve readability.
- Single Write Operation: Update the voter information in one write operation to reduce gas usage.
- Tight Variable Packing: Reordered struct fields to ensure tight packing, reducing the storage slots used and therefore gas costs. 
    Placing the smaller types (`bool` and `uint8`) together helps pack them into a single storage slot efficiently.

*/
