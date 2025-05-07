// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Challenge10.sol";

contract Challenge10Test is Test {
    Challenge10 token;
    address owner;
    address alice;

    function setUp() public {
        // Deploy the contract
        token = new Challenge10();
        owner = address(this); // Contract deployer is the owner
        alice = vm.addr(1);
    }

    function testUnauthorizedMint() public {
        // Initial state
        uint256 initialTotalSupply = token.totalSupply();
        uint256 initialAliceBalance = token.balanceOf(alice);
        assertEq(initialTotalSupply, 1000000 * 10 ** 18); // Initial supply from constructor
        assertEq(initialAliceBalance, 0); // Alice starts with no tokens
        assertEq(token.owner(), owner); // Owner is the deployer

        // Alice (non-owner) mints 1000 ether of tokens to herself
        vm.prank(alice);
        token.mint(alice, 1000 ether);

        // Verify that minting was successful (bug: non-owner should not be able to mint)
        uint256 newTotalSupply = token.totalSupply();
        uint256 newAliceBalance = token.balanceOf(alice);
        assertEq(newTotalSupply, initialTotalSupply + 1000 ether); // Total supply increased
        assertEq(newAliceBalance, 1000 ether); // Alice received the tokens

        // Optionally, test unauthorized ownership transfer
        vm.prank(alice);
        token.transferOwnership(alice);

        // Verify that Alice is now the owner (bug: non-owner should not be able to transfer ownership)
        assertEq(token.owner(), alice);
    }
}