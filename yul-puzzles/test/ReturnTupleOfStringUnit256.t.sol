// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ReturnTupleOfStringUnit256} from "../src/ReturnTupleOfStringUnit256.sol";

contract ReturnTupleOfStringUnit256Test is Test {
    ReturnTupleOfStringUnit256 public c;

    function setUp() public {
        c = new ReturnTupleOfStringUnit256();
    }

    function test_ReturnTupleOfStringUnit256() public {
        (string memory r, uint256 rr) = c.main();

        assertEq(keccak256(abi.encode(r)), keccak256(abi.encode("RareSkills")));
        assertEq(rr, 420);
    }
}
