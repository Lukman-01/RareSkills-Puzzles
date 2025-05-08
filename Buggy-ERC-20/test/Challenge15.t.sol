// // SPDX-License-Identifier: UNLICENSED
// pragma solidity >=0.8.0;

// import "forge-std/Test.sol";
// import "../src/Challenge15.sol";

// // Wrapper contract to call internal _mint
// contract Challenge15Wrapper is Challenge15 {
//     constructor(string memory _name, string memory _symbol, uint8 _decimals) 
//         Challenge15(_name, _symbol, _decimals) {}

//     function mint(address to, uint256 amount) public {
//         _mint(to, amount);
//     }
// }

// contract Challenge15Test is Test {
//     Challenge15Wrapper token;
//     address alice;
//     address bob;
//     address charlie;

//     function setUp() public {
//         // Deploy the wrapper contract
//         token = new Challenge15Wrapper("BuggyToken15", "BUG15", 18);
//         alice = vm.addr(1);
//         bob = vm.addr(2);
//         charlie = vm.addr(3);

//         // Mint 100 ether to Alice
//         token.mint(alice, 100 ether);

//         // Alice approves Bob to spend 50 ether
//         vm.prank(alice);
//         token.approve(bob, 50 ether);
//     }

//     function testMintAndValidationBugs() public {
//         // Test 1: Mint bug - balance not updated
//         assertEq(token.totalSupply(), 100 ether, "Total supply should be 100 ether");
//         assertEq(token.balanceOf(alice), 0, "BUG: Alice's balance should be 0 despite minting");

//         // Manually set Alice's balance to test other functions
//         vm.store(
//             address(token),
//             keccak256(abi.encode(alice, 4)), // balanceOf mapping at slot 4
//             bytes32(uint256(100 ether))
//         );
//         assertEq(token.balanceOf(alice), 100 ether, "Alice's balance manually set to 100 ether");

//         // Initial state
//         uint256 initialAliceBalance = token.balanceOf(alice);
//         uint256 initialBobBalance = token.balanceOf(bob);
//         uint256 initialAllowance = token.allowance(alice, bob);
//         assertEq(initialAliceBalance, 100 ether, "Alice should have 100 tokens");
//         assertEq(initialBobBalance, 0, "Bob should have 0 tokens");
//         assertEq(initialAllowance, 50 ether, "Alice->Bob allowance should be 50");

//         // Test 2: Bob transfers to zero address via transferFrom (should fail but succeeds)
//         vm.prank(bob);
//         token.transferFrom(alice, address(0), 50 ether);

//         // Verify tokens transferred to zero address (bug)
//         assertEq(token.balanceOf(alice), 50 ether, "Alice should have 50 tokens");
//         assertEq(token.balanceOf(address(0)), 50 ether, "Zero address should have 50 tokens");
//         assertEq(token.allowance(alice, bob), 0, "Allowance should be 0");

//         // Test 3: Bob attempts transferFrom with insufficient allowance
//         // Approve Bob for 10 ether
//         vm.prank(alice);
//         token.approve(bob, 10 ether);
//         vm.prank(bob);
//         vm.expectRevert(abi.encodeWithSignature("Panic(uint256)", 0x11)); // Expect arithmetic underflow
//         token.transferFrom(alice, charlie, 20 ether);

//         // Test 4: Alice transfers to zero address (should fail but succeeds)
//         vm.prank(alice);
//         token.transfer(address(0), 50 ether);

//         // Verify tokens transferred to zero address (bug)
//         assertEq(token.balanceOf(alice), 0, "Alice should have 0 tokens");
//         assertEq(token.balanceOf(address(0)), 100 ether, "Zero address should have 100 tokens");

//         // Test 5: Approve zero address (should fail but succeeds)
//         vm.prank(alice);
//         token.approve(address(0), 50 ether);
//         assertEq(token.allowance(alice, address(0)), 50 ether, "BUG: Zero address approved");
//     }
// }