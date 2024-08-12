// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract Presale {
    bool[200] public theLuckyFew; // Array to track whether each of the first 200 addresses have minted
    bytes32 public merkleRoot; // The Merkle root for verifying whitelist addresses

    // Custom errors
    error NotAllowedToMint();
    error AlreadyMinted();

    /// @notice Allows a whitelisted user to mint a token if they haven't already
    /// @param merkleProof The Merkle proof that proves the sender is in the whitelist
    function mint(bytes32[] calldata merkleProof) public {
        uint256 index = uint256(uint160(msg.sender)) % 200; // Calculate the index based on the address

        // Check if the sender has already minted
        if (theLuckyFew[index]) {
            revert AlreadyMinted();
        }

        // Check if the sender is in the Merkle tree
        if (!inTheMerkleTree(msg.sender, merkleProof)) {
            revert NotAllowedToMint();
        }

        // Mark as already minted
        setAlreadyMinted(index);

        // Mint the token (implementation not shown, assume minting logic is handled elsewhere)
    }

    /// @notice Marks the sender's address as having minted a token
    /// @param index The index in theLuckyFew array corresponding to the sender
    function setAlreadyMinted(uint256 index) internal {
        theLuckyFew[index] = true; // Set the corresponding index to true to indicate the address has minted
    }

    /// @notice Verifies that the sender is in the Merkle tree using the provided proof
    /// @param buyer The address of the buyer attempting to mint
    /// @param merkleProof The Merkle proof that proves the buyer is in the whitelist
    /// @return bool Returns true if the buyer is in the Merkle tree, false otherwise
    function inTheMerkleTree(address buyer, bytes32[] calldata merkleProof) internal view returns (bool) {
        // Compute the leaf node from the buyer's address
        bytes32 leaf = keccak256(abi.encodePacked(buyer));
        
        // Verify the proof against the Merkle root
        return MerkleProof.verify(merkleProof, merkleRoot, leaf);
    }

    /// @notice Sets the Merkle root for verifying the whitelist
    /// @dev This function can be used to set or update the Merkle root
    /// @param _merkleRoot The new Merkle root
    function setMerkleRoot(bytes32 _merkleRoot) external {
        merkleRoot = _merkleRoot;
    }
}
