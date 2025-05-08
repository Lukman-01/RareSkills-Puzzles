// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Challenge20.sol";

// Wrapper contract to call internal _mint
contract Challenge20Wrapper is Challenge20 {
    constructor(string memory name, string memory symbol, uint8 decimals)
        Challenge20(name, symbol, decimals)
    {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}

contract Challenge20Test is Test {
    Challenge20Wrapper token;
    address deployer;
    address alice;
    address bob;

    function setUp() public {
        // Deploy the wrapper contract
        token = new Challenge20Wrapper("BuggyToken20", "BUG20", 18);
        deployer = address(this);
        alice = vm.addr(1);
        bob = vm.addr(2);

        // Mint 1000 ether to Alice
        token.mint(alice, 1000 ether);
    }

    function testTransferFromAllowanceBug() public {
        // Initial state
        uint256 initialAliceBalance = token.balanceOf(alice);
        uint256 initialBobBalance = token.balanceOf(bob);
        uint256 initialTotalSupply = token.totalSupply();
        assertEq(initialAliceBalance, 1000 ether, "Alice should have 1000 tokens");
        assertEq(initialBobBalance, 0, "Bob should have 0 tokens");
        assertEq(initialTotalSupply, 1000 ether, "Total supply should be 1000 tokens");

        // Alice approves Bob to spend 100 ether
        uint256 approvedAmount = 100 ether;
        vm.prank(alice);
        token.approve(bob, approvedAmount);
        assertEq(token.allowance(alice, bob), approvedAmount, "Bob should be approved for 100 tokens");

        // Test 1: Bob transfers 100 ether from Alice to himself
        vm.prank(bob);
        bool success = token.transferFrom(alice, bob, approvedAmount);

        // Verify the transfer succeeded
        assertTrue(success, "TransferFrom should succeed");

        // Verify balances and allowance
        assertEq(token.balanceOf(alice), 900 ether, "Alice should have 900 tokens");
        assertEq(token.balanceOf(bob), 100 ether, "Bob should have 100 tokens");
        assertEq(
            token.allowance(alice, bob),
            200 ether,
            "BUG: Bob's allowance incorrectly increased to 200 tokens"
        );

        // Test 2: Bob transfers another 150 ether (exceeding original approval)
        uint256 extraAmount = 150 ether;
        vm.prank(bob);
        success = token.transferFrom(alice, bob, extraAmount);

        // Verify the transfer succeeded (bug: should fail due to insufficient allowance)
        assertTrue(success, "BUG: TransferFrom succeeded despite insufficient original approval");

        // Verify final balances and allowance
        uint256 finalAliceBalance = token.balanceOf(alice);
        uint256 finalBobBalance = token.balanceOf(bob);
        uint256 finalTotalSupply = token.totalSupply();
        assertEq(finalAliceBalance, 750 ether, "Alice should have 750 tokens");
        assertEq(finalBobBalance, 250 ether, "Bob should have 250 tokens");
        assertEq(
            token.allowance(alice, bob),
            350 ether,
            "BUG: Bob's allowance incorrectly increased to 350 tokens"
        );
        assertEq(finalTotalSupply, initialTotalSupply, "Total supply should remain unchanged");

        // Test 3: Verify sum of balances equals total supply
        uint256 sumOfBalances = finalAliceBalance + finalBobBalance + token.balanceOf(deployer);
        assertEq(sumOfBalances, finalTotalSupply, "Sum of balances should equal total supply");
    }
}