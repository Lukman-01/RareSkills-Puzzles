// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ReturnBytes} from "../src/ReturnBytes.sol";

contract ReturnBytesTest is Test {
    ReturnBytes public c;

    function setUp() public {
        c = new ReturnBytes();
    }

    function test_ReturnBytes(address a, uint256 b) public {
        bytes memory r = c.main(a, b);

        bytes memory dd = abi.encode(a, b);

        assertEq(keccak256(r), keccak256(dd));
    }
}
