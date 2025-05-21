// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ReturnBool} from "../src/ReturnBool.sol";

contract ReturnBoolTest is Test {
    ReturnBool public c;

    function setUp() public {
        c = new ReturnBool();
    }

    function test_ReturnBool() public {
        bool r = c.main();
        assertEq(r, true);
    }
}
