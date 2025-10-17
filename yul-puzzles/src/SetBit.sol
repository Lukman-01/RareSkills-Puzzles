// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract SetBit {

  function main(uint256 x, uint8 i) external pure returns (uint256) {
      assembly {
          // Create a mask with only the i-th bit set to 1
          // 1 << i gives us a number with only the i-th bit set
          let mask := shl(i, 1)
          
          // OR the mask with x to set the i-th bit to 1
          let result := or(x, mask)
          
          // Return the result
          mstore(0x00, result)
          return(0x00, 0x20)
     }
  }
}
