// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ReturnTupleOfString} from "../src/ReturnTupleOfString.sol";

contract ReturnTupleOfStringTest is Test {
    ReturnTupleOfString public c;

    function setUp() public {
        c = new ReturnTupleOfString();
    }

    function test_ReturnTupleOfString() public {
        (string memory r, string memory rr) = c.main();

        assertEq(keccak256(abi.encode(r)), keccak256(abi.encode("Hello")));
        assertEq(keccak256(abi.encode(rr)), keccak256(abi.encode("RareSkills")));
    }
}
