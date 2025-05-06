// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Challenge01.sol";

contract TestableChalllenge01 is Challlenge01 {
    constructor(string memory name, string memory symbol) Challlenge01(name, symbol) {}

    function exposedMint(address to, uint256 value) public {
        _mint(to, value);
    }
}

contract Challlenge01Test is Test {
    TestableChalllenge01 token;
    address alice = address(0xA11CE);
    address bob = address(0xB0B);

    function setUp() public {
        token = new TestableChalllenge01("BugToken", "BUG");
        token.exposedMint(alice, 100 ether);
    }

    function testExploitTransferDoesNotReduceBalance() public {
        vm.startPrank(alice);

        assertEq(token.balanceOf(bob), 0);
        assertEq(token.balanceOf(alice), 100 ether);

        token.transfer(bob, 10 ether);

        assertEq(token.balanceOf(bob), 10 ether);
        assertEq(token.balanceOf(alice), 100 ether);  

        token.transfer(bob, 10 ether);
        token.transfer(bob, 10 ether);

        assertEq(token.balanceOf(bob), 30 ether);
        assertEq(token.balanceOf(alice), 100 ether);  

        vm.stopPrank();
    }
}
