// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {FizzBuzz} from "../src/FizzBuzz.sol";

contract FizzBuzzTest is Test {
    FizzBuzz public c;

    function setUp() public {
        c = new FizzBuzz();
    }

    function test_FizzBuzz(uint256 x) public {
        string memory r = c.main(x);

        string memory b;

        if (x % 3 == 0 && x % 5 == 0) {
            b = "fizzbuzz";
        } else if (x % 3 == 0) {
            b = "fizz";
        } else if (x % 5 == 0) {
            b = "buzz";
        } else {
            b = "";
        }
        assertEq(keccak256(abi.encode(r)), keccak256(abi.encode(b)));
    }
}
