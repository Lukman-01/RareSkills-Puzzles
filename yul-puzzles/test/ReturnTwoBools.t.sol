// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ReturnTwoBools} from "../src/ReturnTwoBools.sol";

contract ReturnTwoBoolsTest is Test {
    ReturnTwoBools public c;

    function setUp() public {
        c = new ReturnTwoBools();
    }

    function test_ReturnTwoBools(bool a, bool b) public {
        (bool r, bool rr) = c.main(a, b);

        assertEq(r, a);
        assertEq(rr, b);
    }
}
