// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ReturnSimpleStruct} from "../src/ReturnSimpleStruct.sol";

contract ReturnSimpleStructTest is Test {
    ReturnSimpleStruct public c;

    function setUp() public {
        c = new ReturnSimpleStruct();
    }

    function test_ReturnSimpleStruct(uint256 x, uint256 y) public {
        ReturnSimpleStruct.Point memory r = c.main(x, y);

        assertEq(r.x, x);
        assertEq(r.y, y);
    }
}
