// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Challenge18.sol";

// Wrapper contract to call internal _mint and _burn
contract Challenge18Wrapper is Challenge18 {
    constructor() Challenge18() {}

    function mint(address to, uint256 value) public {
        _mint(to, value);
    }

    function burn(address account, uint256 value) public {
        _burn(account, value);
    }
}

contract Challenge18Test is Test {
    Challenge18Wrapper token;
    address deployer;
    address alice;
    address bob;

    function setUp() public {
        // Deploy the wrapper contract (mints 1,000,000 tokens to deployer)
        token = new Challenge18Wrapper();
        deployer = address(this);
        alice = vm.addr(1);
        bob = vm.addr(2);
    }

    function testMintBug() public {
        // Initial state
        uint256 deployerBalance = token.balanceOf(deployer);
        uint256 totalSupply = token.totalSupply();
        assertEq(deployerBalance, 1000000 ether, "Deployer should have 1,000,000 tokens");
        assertEq(totalSupply, 0, "BUG: Total supply should be 0 despite minting");

        // Test 1: Mint additional tokens to Alice
        vm.prank(deployer);
        token.mint(alice, 100 ether);

        // Verify Alice's balance increased but total supply unchanged
        assertEq(token.balanceOf(alice), 100 ether, "Alice should have 100 tokens");
        assertEq(token.totalSupply(), 0, "BUG: Total supply remains 0 after minting");

        // Test 2: Transfer tokens from deployer to Bob
        vm.prank(deployer);
        token.transfer(bob, 200 ether);

        // Verify transfer succeeded but total supply unchanged
        assertEq(token.balanceOf(deployer), 1000000 ether - 200 ether, "Deployer should have 999,800 tokens");
        assertEq(token.balanceOf(bob), 200 ether, "Bob should have 200 tokens");
        assertEq(token.totalSupply(), 0, "BUG: Total supply remains 0 after transfer");

        // Test 3: Burn tokens from Bob
        vm.prank(bob);
        token.burn(bob, 100 ether);

        // Verify burn succeeded but total supply underflows
        assertEq(token.balanceOf(bob), 100 ether, "Bob should have 100 tokens after burn");
        assertEq(
            token.totalSupply(),
            type(uint256).max - 100 ether + 1,
            "BUG: Total supply underflows to 2^256 - 100 ether due to burn when totalSupply is 0"
        );

        // Test 4: Verify sum of balances exceeds total supply
        uint256 sumOfBalances = token.balanceOf(deployer) + token.balanceOf(alice) + token.balanceOf(bob);
        assertEq(sumOfBalances, 1000000 ether, "Sum of balances should be 1,000,000 tokens");
        assertTrue(sumOfBalances < token.totalSupply(), "BUG: Sum of balances is less than total supply after underflow");
    }
}