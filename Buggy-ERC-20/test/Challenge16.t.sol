// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Challenge16.sol";

contract Challenge16Test is Test {
    Challenge16 token;
    address deployer;
    address alice;
    address bob;
    address charlie;

    function setUp() public {
        // Deploy the contract (mints 1,000,000 tokens to deployer)
        token = new Challenge16();
        deployer = address(this);
        alice = vm.addr(1);
        bob = vm.addr(2);
        charlie = vm.addr(3);

        // Transfer 100 ether to Alice for testing
        vm.prank(deployer);
        token.transfer(alice, 100 ether);

        // Alice approves Bob to spend 50 ether
        vm.prank(alice);
        token.approve(bob, 50 ether);
    }

    function testApproveBug() public {
        // Initial state
        uint256 initialAliceBalance = token.balanceOf(alice);
        uint256 initialBobBalance = token.balanceOf(bob);
        uint256 initialAllowance = token.allowance(alice, bob);
        assertEq(initialAliceBalance, 100 ether, "Alice should have 100 tokens");
        assertEq(initialBobBalance, 0, "Bob should have 0 tokens");
        assertEq(initialAllowance, 0, "BUG: Alice->Bob allowance should be 0 despite approve");

        // Test 1: Verify approve bug - allowance not updated
        vm.prank(alice);
        bool success = token.approve(bob, 50 ether);
        assertTrue(success, "Approve function should return true");
        assertEq(token.allowance(alice, bob), 0, "BUG: Alice->Bob allowance remains 0");

        // Test 2: Bob attempts transferFrom (should fail due to zero allowance)
        vm.prank(bob);
        vm.expectRevert("ERC20: insufficient allowance");
        token.transferFrom(alice, charlie, 20 ether);

        // Verify no tokens were transferred
        assertEq(token.balanceOf(alice), 100 ether, "Alice's balance should remain 100 tokens");
        assertEq(token.balanceOf(charlie), 0, "Charlie should have 0 tokens");

        // Test 3: Use increaseAllowance as a workaround
        vm.prank(alice);
        token.increaseAllowance(bob, 50 ether);
        assertEq(token.allowance(alice, bob), 50 ether, "Alice->Bob allowance should be 50 after increaseAllowance");

        // Test 4: Bob transfers with valid allowance
        vm.prank(bob);
        token.transferFrom(alice, charlie, 20 ether);

        // Verify transfer succeeded
        assertEq(token.balanceOf(alice), 80 ether, "Alice should have 80 tokens");
        assertEq(token.balanceOf(charlie), 20 ether, "Charlie should have 20 tokens");
        assertEq(token.allowance(alice, bob), 30 ether, "Allowance should be reduced to 30");
    }
}