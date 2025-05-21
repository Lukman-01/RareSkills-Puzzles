// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract ReturnTupleOfUint256String {
    function main() external pure returns (uint256, string memory) {
        assembly {
            // your code here
            // return the tuple of (uint256 and string): (420, "RareSkills")
        }
    }
}
