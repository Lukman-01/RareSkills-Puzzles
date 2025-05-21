// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract WriteToMapping {
    mapping(uint256 index => uint256) public writeHere;

    function main(uint256 index, uint256 value) external {
        assembly {
            // your code here
            // store `value` at the `index` in the mapping `writeHere`
            // Hint: https://www.rareskills.io/post/solidity-dynamic
        }
    }
}
