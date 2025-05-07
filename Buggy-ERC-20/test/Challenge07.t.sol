// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import "forge-std/Test.sol";
import "../src/Challenge07.sol";

contract Challenge07Test is Test {
    Challenge07 token;
    address owner;
    address alice;

    function setUp() public {
        // Deploy the contract
        token = new Challenge07();
        owner = address(this); // Contract deployer is the owner
        alice = vm.addr(1);
    }

    function testUnauthorizedMint() public {
        // Initial state
        uint256 initialTotalSupply = token.totalSupply();
        uint256 initialAliceBalance = token.balanceOf(alice);
        assertEq(initialTotalSupply, 1000000 * 10 ** 18); // Initial supply from constructor
        assertEq(initialAliceBalance, 0); // Alice starts with no tokens

        // Alice (non-owner) mints 1000 ether of tokens to herself
        vm.prank(alice);
        token.mint(alice, 1000 ether);

        // Verify that minting was successful
        uint256 newTotalSupply = token.totalSupply();
        uint256 newAliceBalance = token.balanceOf(alice);
        assertEq(newTotalSupply, initialTotalSupply + 1000 ether); // Total supply increased
        assertEq(newAliceBalance, 1000 ether); // Alice received the tokens
    }
}