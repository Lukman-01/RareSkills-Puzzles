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
        
        // Optimized check with proper error handling
        if (sender.voted) {
            revert AlreadyVoted();
        }
        
        // Cache proposals length to avoid multiple SLOAD
        uint256 proposalsLength = proposals.length;
        if (_proposal >= proposalsLength) {
            revert InvalidProposal();
        }

        // Optimized storage writes
        unchecked {
            // Set voter data efficiently
            sender.vote = _proposal;
            sender.voted = true;

            // Pre-increment for gas efficiency
            ++proposals[_proposal].voteCount;
        }
    }

    function getVoteCount(uint8 _proposal) external view returns (uint8) {
        return proposals[_proposal].voteCount;
    }
}