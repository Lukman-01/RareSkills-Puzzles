// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract AbsoluteValue{

  function main(int256 x) external pure returns (uint256) {
      assembly {
          // Check if x is negative by checking the sign bit
          // If x < 0, we need to negate it
          // We can use slt (signed less than) to compare with 0
          
          // Store x in a temporary variable
          let temp := x
          
          // Check if x is negative (x < 0)
          if slt(x, 0) {
              // If negative, negate it: -x = ~x + 1 (two's complement)
              temp := add(not(x), 1)
          }
          
          // Return the absolute value
          mstore(0x0, temp)
          return(0x0, 0x20)
      }
  }
}