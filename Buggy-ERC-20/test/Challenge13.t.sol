// // SPDX-License-Identifier: UNLICENSED
// pragma solidity >=0.8.0;

// import "forge-std/Test.sol";
// import "../src/Challenge13.sol";

// // Wrapper contract to call internal _mint
// contract Challenge13Wrapper is Challenge13 {
//     constructor(string memory _name, string memory _symbol, uint8 _decimals) 
//         Challenge13(_name, _symbol, _decimals) {}

//     function mint(address to, uint256 amount) public {
//         _mint(to, amount);
//     }
// }

// contract ApprovalBugTest is Test {
//     Challenge13Wrapper token;
//     address alice;
//     address bob;
//     address charlie;

//     function setUp() public {
//         // Deploy the wrapper contract
//         token = new Challenge13Wrapper("ApprovalBugToken", "ABT", 18);
//         alice = vm.addr(1);
//         bob = vm.addr(2);
//         charlie = vm.addr(3);
        
//         // Mint 100 tokens to Alice for testing
//         token.mint(alice, 100 ether);
//     }

//     function testApprovalAndValidationBugs() public {
//         // Step 1: Initial state check
//         assertEq(token.balanceOf(alice), 100 ether, "Alice should have 100 tokens");
//         assertEq(token.balanceOf(bob), 0, "Bob should have 0 tokens");
//         assertEq(token.allowance(alice, bob), 0, "Initial Alice->Bob allowance should be 0");
//         assertEq(token.allowance(bob, alice), 0, "Initial Bob->Alice allowance should be 0");

//         // Step 2: Alice approves Bob to spend 50 tokens
//         vm.prank(alice);
//         bool success = token.approve(bob, 50 ether);
//         assertTrue(success, "Approve function should return true");

//         // Step 3: Verify the bug - allowance is set in the wrong direction
//         assertEq(token.allowance(alice, bob), 0, "BUG: Alice->Bob allowance incorrectly remains 0");
//         assertEq(token.allowance(bob, alice), 50 ether, "BUG: Bob->Alice allowance incorrectly set to 50");

//         // Step 4: Bob attempts to transfer from Alice to Charlie (should fail)
//         vm.prank(bob);
//         vm.expectRevert(abi.encodeWithSignature("Panic(uint256)", 0x11)); // Expect arithmetic underflow
//         token.transferFrom(alice, charlie, 20 ether);
        
//         // Step 5: Verify no tokens were transferred
//         assertEq(token.balanceOf(alice), 100 ether, "Alice's balance should remain 100 tokens");
//         assertEq(token.balanceOf(charlie), 0, "Charlie should still have 0 tokens");

//         // Step 6: Fix the wrong allowance manually to demonstrate correct behavior
//         // Allowance slots: keccak256(abi.encode(spender, keccak256(abi.encode(owner, 5))))
//         bytes32 bobAliceSlot = keccak256(abi.encode(alice, keccak256(abi.encode(bob, 5))));
//         bytes32 aliceBobSlot = keccak256(abi.encode(bob, keccak256(abi.encode(alice, 5))));
        
//         // Clear the wrong allowance
//         vm.store(address(token), bobAliceSlot, bytes32(uint256(0)));
//         // Set the correct allowance
//         vm.store(address(token), aliceBobSlot, bytes32(uint256(50 ether)));
        
//         // Verify fixed allowances
//         assertEq(token.allowance(alice, bob), 50 ether, "Fixed: Alice->Bob allowance should be 50");
//         assertEq(token.allowance(bob, alice), 0, "Fixed: Bob->Alice allowance should be 0");
        
//         // Step 7: Bob transfers to Charlie with fixed allowance
//         vm.prank(bob);
//         token.transferFrom(alice, charlie, 20 ether);
        
//         // Verify transfer succeeded
//         assertEq(token.balanceOf(alice), 80 ether, "Alice should now have 80 tokens");
//         assertEq(token.balanceOf(charlie), 20 ether, "Charlie should now have 20 tokens");
//         assertEq(token.allowance(alice, bob), 30 ether, "Allowance should be reduced to 30");

//         // Step 8: Test zero address transfer (should fail but succeeds)
//         vm.prank(bob);
//         token.transferFrom(alice, address(0), 20 ether);

//         // Verify tokens transferred to zero address (bug)
//         assertEq(token.balanceOf(alice), 60 ether, "Alice should now have 60 tokens");
//         assertEq(token.balanceOf(address(0)), 20 ether, "Zero address should have 20 tokens");
//         assertEq(token.allowance(alice, bob), 10 ether, "Allowance should be reduced to 10");
//     }
// }