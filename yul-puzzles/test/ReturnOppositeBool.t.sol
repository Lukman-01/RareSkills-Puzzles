// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ReturnOppositeBool} from "../src/ReturnOppositeBool.sol";

contract ReturnOppositeBoolTest is Test {
    ReturnOppositeBool public c;

    function setUp() public {
        c = new ReturnOppositeBool();
    }

    function test_ReturnOppositeBool(bool x) public {
        bool r = c.main(x);
        assertEq(r, !x);
    }
}
