// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ReturnArrayOfUint256} from "../src/ReturnArrayOfUint256.sol";

contract ReturnArrayOfUint256Test is Test {
    ReturnArrayOfUint256 public x;

    function setUp() public {
        x = new ReturnArrayOfUint256();
    }

    function test_ReturnArrayOfUint256(uint256 a, uint256 b, uint256 c) public {
        uint256[] memory r = x.main(a, b, c);

        assertEq(r[0], a);
        assertEq(r[1], b);
        assertEq(r[2], c);
    }
}
