// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Challenge11.sol";

contract Challenge11Test is Test {
    Challenge11 token;
    address owner;
    address alice;
    address bob;

    function setUp() public {
        // Deploy the contract
        token = new Challenge11();
        owner = address(this); // Contract deployer
        alice = vm.addr(1);
        bob = vm.addr(2);

        // Transfer 1000 ether of tokens to Alice
        token.transfer(alice, 1000 ether);

        // Alice approves Bob to spend 500 ether
        vm.prank(alice);
        token.approve(bob, 500 ether);
    }

    function testTransferFromAllowanceBug() public {
        // Initial state
        uint256 initialAliceBalance = token.balanceOf(alice);
        uint256 initialBobBalance = token.balanceOf(bob);
        uint256 initialAllowance = token.allowance(alice, bob);
        assertEq(initialAliceBalance, 1000 ether); // Alice has 1000 ether
        assertEq(initialBobBalance, 0); // Bob has 0 tokens
        assertEq(initialAllowance, 500 ether); // Bob is approved for 500 ether

        // Bob transfers 300 ether from Alice to himself
        vm.prank(bob);
        token.transferFrom(alice, bob, 300 ether);

        // Verify balances
        uint256 newAliceBalance = token.balanceOf(alice);
        uint256 newBobBalance = token.balanceOf(bob);
        assertEq(newAliceBalance, 700 ether); // Alice loses 300 ether
        assertEq(newBobBalance, 300 ether); // Bob gains 300 ether

        // Verify allowance (bug: allowance is not reduced)
        uint256 newAllowance = token.allowance(alice, bob);
        assertEq(newAllowance, 500 ether); // Allowance unchanged (should be 200 ether)

        // Bob can transfer again using the same allowance
        vm.prank(bob);
        token.transferFrom(alice, bob, 300 ether);

        // Verify balances after second transfer
        assertEq(token.balanceOf(alice), 400 ether); // Alice loses another 300 ether
        assertEq(token.balanceOf(bob), 600 ether); // Bob gains another 300 ether
        assertEq(token.allowance(alice, bob), 500 ether); // Allowance still unchanged
    }
}