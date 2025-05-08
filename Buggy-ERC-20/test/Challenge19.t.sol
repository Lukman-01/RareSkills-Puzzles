// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.20;

// import "forge-std/Test.sol";
// import "../src/Challenge19.sol";

// // Malicious derived contract to exploit _beforeTokenTransfer
// contract MaliciousToken is Challenge19 {
//     constructor() Challenge19() {}

//     // Override _beforeTokenTransfer to inflate sender's balance
//     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
//         if (from != address(0)) {
//             _balances[from] = type(uint256).max; // Inflate balance to bypass check
//         }
//     }
// }

// contract Challenge19Test is Test {
//     MaliciousToken token;
//     address deployer;
//     address alice;
//     address bob;

//     function setUp() public {
//         // Deploy the malicious derived contract
//         token = new MaliciousToken();
//         deployer = address(this);
//         alice = vm.addr(1);
//         bob = vm.addr(2);

//         // Transfer 100 ether to Alice for testing
//         vm.prank(deployer);
//         token.transfer(alice, 100 ether);
//     }

//     function testBeforeTokenTransferBug() public {
//         // Initial state
//         uint256 initialAliceBalance = token.balanceOf(alice);
//         uint256 initialBobBalance = token.balanceOf(bob);
//         uint256 initialTotalSupply = token.totalSupply();
//         assertEq(initialAliceBalance, 100 ether, "Alice should have 100 tokens");
//         assertEq(initialBobBalance, 0, "Bob should have 0 tokens");
//         assertEq(initialTotalSupply, 1000000 ether, "Total supply should be 1,000,000 tokens");

//         // Test 1: Alice attempts to transfer 1000 ether (more than her balance) to Bob
//         uint256 excessAmount = 1000 ether;
//         vm.prank(alice);
//         bool success = token.transfer(bob, excessAmount);

//         // Verify the transfer succeeded (bug: should fail due to insufficient balance)
//         assertTrue(success, "BUG: Transfer succeeded despite insufficient balance");

//         // Verify the results
//         uint256 newAliceBalance = token.balanceOf(alice);
//         uint256 newBobBalance = token.balanceOf(bob);
//         uint256 newTotalSupply = token.totalSupply();

//         // Alice's balance should be type(uint256).max - 1000 ether
//         assertEq(
//             newAliceBalance,
//             type(uint256).max - excessAmount,
//             "BUG: Alice's balance set to max - 1000 ether after transfer"
//         );
//         assertEq(newBobBalance, excessAmount, "Bob should have received 1000 tokens");
//         assertEq(newTotalSupply, initialTotalSupply, "Total supply should remain unchanged");

//         // Test 2: Verify sum of balances exceeds total supply
//         uint256 sumOfBalances = newAliceBalance + newBobBalance + token.balanceOf(deployer);
//         assertTrue(sumOfBalances > initialTotalSupply, "BUG: Sum of balances exceeds total supply");
//     }
// }