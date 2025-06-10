// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract Return42 {
  function main() external pure returns (uint256) {
    assembly {
      // Store 42 in memory at position 0x00
      mstore(0x00, 42)
      // Return 32 bytes starting from position 0x00
      return(0x00, 0x20)
    }
  }
}
