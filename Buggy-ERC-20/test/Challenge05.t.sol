// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Challenge05.sol";

contract Challenge05Test is Test {
    Challenge05 token;
    address alice;
    address bob;

    function setUp() public {
        token = new Challenge05();
        alice = vm.addr(1);
        bob = vm.addr(2);

        token.transfer(bob, 1000 ether);     // Bob gets 1000 ether
        token.transfer(alice, 1000 ether);   // Alice gets 1000 ether

        vm.prank(bob);
        token.approve(alice, 500 ether);     // Bob approves Alice to spend 500 ether
    }

    function testExploitReverseTransfer() public {
        // Before transferFrom
        assertEq(token.balanceOf(alice), 1000 ether); // Alice starts with 1000 ether
        assertEq(token.balanceOf(bob), 1000 ether);   // Bob starts with 1000 ether

        // Alice initiates transferFrom to transfer 300 ether from Bob to herself
        vm.prank(alice);
        token.transferFrom(bob, alice, 300 ether);

        // ❌ Due to reversed _transfer params, tokens are taken from Alice and given to Bob
        assertEq(token.balanceOf(alice), 700 ether);  // Alice loses 300 ether (1000 - 300)
        assertEq(token.balanceOf(bob), 1300 ether);   // Bob gains 300 ether (1000 + 300)
    }
}