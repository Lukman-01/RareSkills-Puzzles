// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ReturnTupleOfUint256String} from "../src/ReturnTupleOfUint256String.sol";

contract ReturnTupleOfUint256StringTest is Test {
    ReturnTupleOfUint256String public c;

    function setUp() public {
        c = new ReturnTupleOfUint256String();
    }

    function test_ReturnTupleOfUint256String() public {
        (uint256 r, string memory rr) = c.main();

        assertEq(r, 420);
        assertEq(keccak256(abi.encode(rr)), keccak256(abi.encode("RareSkills")));
    }
}
