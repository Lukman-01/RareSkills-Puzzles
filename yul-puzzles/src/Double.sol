// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract Double {

  function main(uint256 x) external pure returns (uint256) {
      assembly {
          // Multiply x by 2 and store the result
          let result := mul(x, 2)
          
          // Return the result
          mstore(0x00, result)
          return(0x00, 0x20)
      }
  }
}