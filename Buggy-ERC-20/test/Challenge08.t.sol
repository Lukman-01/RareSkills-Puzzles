// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Challenge08.sol";

contract Challenge08Test is Test {
    Challenge08 token;
    address owner;
    address alice;

    function setUp() public {
        // Deploy the contract
        token = new Challenge08();
        owner = address(this); // Contract deployer
        alice = vm.addr(1);

        // Transfer 1000 ether of tokens to Alice
        token.transfer(alice, 1000 ether);
    }

    function testBurnBugs() public {
        // Initial state
        uint256 initialTotalSupply = token.totalSupply();
        uint256 initialAliceBalance = token.balanceOf(alice);
        assertEq(initialTotalSupply, 1000000 * 10 ** 18); // Initial supply from constructor
        assertEq(initialAliceBalance, 1000 ether); // Alice has 1000 ether

        // Test 1: Attempt to burn more tokens than Alice's balance
        vm.prank(alice);
        vm.expectRevert(); // Expect revert due to underflow in Solidity 0.8.0+
        token.burn(1001 ether); // Try to burn more than Alice's balance

        // Test 2: Burn a valid amount and check total supply
        vm.prank(alice);
        token.burn(500 ether); // Burn 500 ether

        // Verify balances and total supply
        uint256 newAliceBalance = token.balanceOf(alice);
        uint256 newTotalSupply = token.totalSupply();
        assertEq(newAliceBalance, 500 ether); // Alice's balance decreased
        assertEq(newTotalSupply, initialTotalSupply); // Total supply unchanged (bug)
    }
}