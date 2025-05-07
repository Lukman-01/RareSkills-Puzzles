// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import "forge-std/Test.sol";
import "../src/Challenge12.sol";

contract Challenge12Test is Test {
    Challenge12 token;
    address owner;
    address alice;
    address bob;

    function setUp() public {
        // Deploy the contract
        token = new Challenge12("BuggyToken12", "BUG12", 18);
        owner = address(this); // Contract deployer
        alice = vm.addr(1);
        bob = vm.addr(2);

        // Mint 100 ether to Alice using gift
        vm.prank(owner);
        token.gift(alice, 100 ether);

        // Alice approves Bob to spend 50 ether
        vm.prank(alice);
        token.approve(bob, 50 ether);
    }

    function testTransferFromAndGiftBugs() public {
        // Initial state
        uint256 initialAliceBalance = token.balanceOf(alice);
        uint256 initialBobBalance = token.balanceOf(bob);
        uint256 initialAllowance = token.allowance(alice, bob);
        uint256 initialTotalSupply = token.totalSupply();
        assertEq(initialAliceBalance, 100 ether); // Alice has 100 ether
        assertEq(initialBobBalance, 0); // Bob has 0 tokens
        assertEq(initialAllowance, 50 ether); // Bob is approved for 50 ether
        assertEq(initialTotalSupply, 0); // Bug: totalSupply not updated by gift

        // Test 1: Bob attempts to transfer 150 ether (exceeds Alice's balance)
        vm.prank(bob);
        vm.expectRevert(); // Expect revert due to balance underflow
        token.transferFrom(alice, bob, 150 ether);

        // Test 2: Bob attempts to transfer 75 ether (exceeds allowance but not balance)
        vm.prank(bob);
        vm.expectRevert(); // Expect revert due to allowance underflow
        token.transferFrom(alice, bob, 75 ether);

        // Test 3: Bob transfers to zero address (should fail but succeeds)
        vm.prank(bob);
        token.transferFrom(alice, address(0), 50 ether);

        // Verify that tokens were transferred to zero address (bug)
        assertEq(token.balanceOf(alice), 50 ether); // Alice loses 50 ether
        assertEq(token.balanceOf(address(0)), 50 ether); // Zero address gains 50 ether
        assertEq(token.allowance(alice, bob), 0); // Allowance is reduced to 0
        assertEq(token.totalSupply(), 0); // Bug: totalSupply still 0

        // Test 4: For completeness, test transfer function to zero address
        vm.prank(alice);
        token.transfer(address(0), 50 ether);

        // Verify that tokens were transferred to zero address (bug)
        assertEq(token.balanceOf(alice), 0); // Alice loses remaining 50 ether
        assertEq(token.balanceOf(address(0)), 100 ether); // Zero address now has 100 ether
        assertEq(token.totalSupply(), 0); // Bug: totalSupply still 0
    }
}