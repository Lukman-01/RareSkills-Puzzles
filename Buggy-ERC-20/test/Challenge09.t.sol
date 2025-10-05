// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import "forge-std/Test.sol";
import "../src/Challenge09.sol";

contract Challenge09Test is Test {
    Challenge09 token;
    address owner;
    address alice;
    address bob;

    function setUp() public {
        // Deploy the contract
        token = new Challenge09();
        owner = address(this); // Contract deployer
        alice = vm.addr(1);
        bob = vm.addr(2);

        // Transfer 1000 ether of tokens to Alice
        token.transfer(alice, 1000 ether);
    }

    function testTransferBalanceUnderflow() public {
        // Initial state
        uint256 initialAliceBalance = token.balanceOf(alice);
        uint256 initialBobBalance = token.balanceOf(bob);
        uint256 initialTotalSupply = token.totalSupply();
        assertEq(initialAliceBalance, 1000 ether); // Alice has 1000 ether
        assertEq(initialBobBalance, 0); // Bob has 0 tokens
        assertEq(initialTotalSupply, 1000000 * 10 ** 18); // Initial supply from constructor

        // Alice attempts to transfer 1001 ether (more than her balance) to Bob
        uint256 excessAmount = 1001 ether;
        vm.prank(alice);
        bool success = token.transfer(bob, excessAmount);

        // Verify the transfer succeeded (bug: it should fail due to insufficient balance)
        assertTrue(success);

        // Verify the results
        uint256 newAliceBalance = token.balanceOf(alice);
        uint256 newBobBalance = token.balanceOf(bob);
        uint256 newTotalSupply = token.totalSupply();

        // Alice's balance should underflow
        // 1000 ether - 1001 ether in unchecked = type(uint256).max - 1 ether + 1
        assertEq(newAliceBalance, type(uint256).max - 1 ether + 1);
        assertEq(newBobBalance, excessAmount); // Bob received 1001 ether
        assertEq(newTotalSupply, initialTotalSupply); // Total supply unchanged
    }
}
