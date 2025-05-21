// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ReturnString} from "../src/ReturnString.sol";

contract ReturnStringTest is Test {
    ReturnString public c;

    function setUp() public {
        c = new ReturnString();
    }

    function test_ReturnString() public {
        string memory r = c.main();

        assertEq(keccak256(abi.encode(r)), keccak256(abi.encode("Hello, RareSkills")));
    }
}
