// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract RevertWithSelector {
    error RevertData(); // selector: 0xa3b7e096

    function main() external pure {
        assembly {
            // Store the error selector in memory
            mstore(0x00, 0xa3b7e09600000000000000000000000000000000000000000000000000000000)
            // Revert with the selector (4 bytes)
            revert(0x00, 0x04)
        }
    }
}