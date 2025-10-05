// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Challenge17.sol";

contract Challenge17Test is Test {
    Challenge17 token;
    address deployer;
    address alice;
    address bob;
    address charlie;

    function setUp() public {
        // Deploy the contract (mints 1,000,000 tokens to deployer)
        token = new Challenge17();
        deployer = address(this);
        alice = vm.addr(1);
        bob = vm.addr(2);
        charlie = vm.addr(3);

        // Manually set balances to avoid buggy transfer
        // _balances mapping is at slot 0
        vm.store(
            address(token),
            keccak256(abi.encode(alice, 0)),
            bytes32(uint256(100 ether))
        );
        vm.store(
            address(token),
            keccak256(abi.encode(bob, 0)),
            bytes32(uint256(10 ether))
        );
    }

    function testTransferBug() public {
        // Initial state
        assertEq(token.balanceOf(alice), 100 ether, "Alice should have 100 tokens");
        assertEq(token.balanceOf(bob), 10 ether, "Bob should have 10 tokens");
        assertEq(token.balanceOf(charlie), 0, "Charlie should have 0 tokens");
        assertEq(token.balanceOf(deployer), 1000000 ether, "Deployer should have 1,000,000 tokens");
        assertEq(token.totalSupply(), 1000000 ether, "Total supply should be 1,000,000 tokens");

        // Test 1: Alice tries to transfer 20 ether to Charlie (fails due to Charlie's 0 balance)
        vm.prank(alice);
        vm.expectRevert("ERC20: transfer amount exceeds balance");
        token.transfer(charlie, 20 ether);

        // Verify no tokens were transferred
        assertEq(token.balanceOf(alice), 100 ether, "Alice's balance should remain 100 tokens");
        assertEq(token.balanceOf(charlie), 0, "Charlie's balance should remain 0 tokens");

        // Test 2: Deployer tries to transfer 100 ether to Charlie (fails due to Charlie's 0 balance)
        vm.prank(deployer);
        vm.expectRevert("ERC20: transfer amount exceeds balance");
        token.transfer(charlie, 100 ether);

        // Verify no tokens were transferred
        assertEq(token.balanceOf(deployer), 1000000 ether, "Deployer's balance should remain 1,000,000 tokens");
        assertEq(token.balanceOf(charlie), 0, "Charlie's balance should remain 0 tokens");

        // Test 3: Alice transfers 5 ether to Bob (succeeds, but corrupts Alice's balance)
        vm.prank(alice);
        token.transfer(bob, 5 ether);

        // Verify transfer occurred but Alice's balance is incorrect
        assertEq(token.balanceOf(alice), 5 ether, "BUG: Alice's balance incorrectly set to 5 (Bob's initial 10 - 5)");
        assertEq(token.balanceOf(alice), 5 ether, "BUG: Expected Alice's balance to be 95 ether");
        assertEq(token.balanceOf(bob), 15 ether, "Bob should have 15 tokens");

        // Test 4: Bob transfers 10 ether to Alice (succeeds since Alice now has 5 ether >= 10 is false)
        // We need to transfer to someone with sufficient balance
        // Let's transfer from Bob to Alice instead
        vm.prank(bob);
        token.transfer(alice, 3 ether);

        // Verify transfer occurred but Bob's balance is incorrect
        assertEq(token.balanceOf(bob), 2 ether, "BUG: Bob's balance incorrectly set to 2 (Alice's 5 - 3)");
        assertEq(token.balanceOf(alice), 8 ether, "Alice should have 8 tokens");

        // Test 5: Set Charlie's balance manually to allow transfer
        vm.store(
            address(token),
            keccak256(abi.encode(charlie, 0)),
            bytes32(uint256(15 ether))
        );
        
        // Now Bob can transfer to Charlie
        vm.prank(bob);
        token.transfer(charlie, 2 ether);
        
        assertEq(token.balanceOf(bob), 13 ether, "BUG: Bob's balance incorrectly set to 13 (Charlie's 15 - 2)");
        assertEq(token.balanceOf(charlie), 17 ether, "Charlie should have 17 tokens");

        // Test 6: Verify total supply remains unchanged
        assertEq(token.totalSupply(), 1000000 ether, "Total supply should remain unchanged");
    }
}
