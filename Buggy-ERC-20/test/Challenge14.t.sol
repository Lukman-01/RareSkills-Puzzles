// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import "forge-std/Test.sol";
import "../src/Challenge14.sol";

// Wrapper contract to call internal _mint
contract Challenge14Wrapper is Challenge14 {
    constructor(string memory _name, string memory _symbol, uint8 _decimals) 
        Challenge14(_name, _symbol, _decimals) {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}

contract Challenge14Test is Test {
    Challenge14Wrapper token;
    address alice;
    address bob;
    address charlie;

    function setUp() public {
        // Deploy the wrapper contract
        token = new Challenge14Wrapper("BuggyToken14", "BUG14", 18);
        alice = vm.addr(1);
        bob = vm.addr(2);
        charlie = vm.addr(3);

        // Mint 100 ether to Alice
        token.mint(alice, 100 ether);

        // Alice approves Bob to spend 50 ether
        vm.prank(alice);
        token.approve(bob, 50 ether);
    }

    function testTransferFromAndValidationBugs() public {
        // Initial state
        uint256 initialAliceBalance = token.balanceOf(alice);
        uint256 initialBobBalance = token.balanceOf(bob);
        uint256 initialAllowance = token.allowance(alice, bob);
        uint256 initialTotalSupply = token.totalSupply();
        assertEq(initialAliceBalance, 100 ether, "Alice should have 100 tokens");
        assertEq(initialBobBalance, 0, "Bob should have 0 tokens");
        assertEq(initialAllowance, 50 ether, "Alice->Bob allowance should be 50");
        assertEq(initialTotalSupply, 100 ether, "Total supply should be 100");

        // Test 1: Bob transfers 50 ether from Alice to Charlie
        vm.prank(bob);
        token.transferFrom(alice, charlie, 50 ether);

        // Verify transfer succeeded
        assertEq(token.balanceOf(alice), 50 ether, "Alice should have 50 tokens");
        assertEq(token.balanceOf(charlie), 50 ether, "Charlie should have 50 tokens");
        assertEq(token.allowance(alice, bob), 50 ether, "BUG: Allowance not reduced");

        // Test 2: Bob transfers another 50 ether (should fail but succeeds due to bug)
        vm.prank(bob);
        token.transferFrom(alice, charlie, 50 ether);

        // Verify second transfer succeeded (bug)
        assertEq(token.balanceOf(alice), 0, "Alice should have 0 tokens");
        assertEq(token.balanceOf(charlie), 100 ether, "Charlie should have 100 tokens");
        assertEq(token.allowance(alice, bob), 50 ether, "BUG: Allowance still not reduced");

        // Test 3: Bob transfers to zero address (should fail but succeeds)
        // Reset allowance and mint more tokens to Alice
        vm.prank(alice);
        token.approve(bob, 50 ether);
        token.mint(alice, 50 ether);

        vm.prank(bob);
        token.transferFrom(alice, address(0), 50 ether);

        // Verify tokens transferred to zero address (bug)
        assertEq(token.balanceOf(alice), 0, "Alice should have 0 tokens");
        assertEq(token.balanceOf(address(0)), 50 ether, "Zero address should have 50 tokens");
        assertEq(token.allowance(alice, bob), 50 ether, "BUG: Allowance not reduced");

        // Test 4: Alice transfers to zero address (should fail but succeeds)
        token.mint(alice, 50 ether);
        vm.prank(alice);
        token.transfer(address(0), 50 ether);

        // Verify tokens transferred to zero address (bug)
        assertEq(token.balanceOf(alice), 0, "Alice should have 0 tokens");
        assertEq(token.balanceOf(address(0)), 100 ether, "Zero address should have 100 tokens");

        // Test 5: Approve zero address (should fail but succeeds)
        vm.prank(alice);
        token.approve(address(0), 50 ether);
        assertEq(token.allowance(alice, address(0)), 50 ether, "BUG: Zero address approved");
    }
}