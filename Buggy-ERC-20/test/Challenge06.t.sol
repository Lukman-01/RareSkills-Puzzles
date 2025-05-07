// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Challenge06.sol";

contract Challenge06Test is Test {
    Challenge06 token;
    address owner;
    address alice;
    address bob;

    function setUp() public {
        // Deploy the contract
        token = new Challenge06();
        owner = address(this); // Contract deployer is the owner
        alice = vm.addr(1);
        bob = vm.addr(2);

        // Transfer 1000 ether of tokens to Alice
        token.transfer(alice, 1000 ether);
    }

    function testBlacklistApproveBypass() public {
        // Initial balances
        assertEq(token.balanceOf(alice), 1000 ether);
        assertEq(token.balanceOf(bob), 0);
        assertEq(token.allowance(alice, bob), 0);

        // Blacklist Alice
        token.addToBlacklist(alice);
        assertTrue(token.blacklist(alice));

        // Alice, while blacklisted, approves Bob to spend 500 ether
        vm.prank(alice);
        token.approve(bob, 500 ether);

        // Verify that the approval was successful
        assertEq(token.allowance(alice, bob), 500 ether);

        // Remove Alice from the blacklist
        token.removeFromBlacklist(alice);
        assertFalse(token.blacklist(alice));

        // Bob uses the allowance to transfer 300 ether from Alice to himself
        vm.prank(bob);
        token.transferFrom(alice, bob, 300 ether);

        // Verify the transfer occurred
        assertEq(token.balanceOf(alice), 700 ether); // 1000 - 300
        assertEq(token.balanceOf(bob), 300 ether);   // 0 + 300
        assertEq(token.allowance(alice, bob), 200 ether); // 500 - 300
    }
}