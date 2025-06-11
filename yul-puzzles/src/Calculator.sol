// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

contract Calculator {
    // perform the arithmetic operations assumming they won't overflow or underflow
    // the list of math operations can be found here:
    // https://docs.soliditylang.org/en/latest/yul.html#evm-dialect

    function add(uint256 x, uint256 y) external pure returns (uint256) {
        assembly {
            // Add x and y
            let result := add(x, y)
            
            // Store result in memory and return
            mstore(0x00, result)
            return(0x00, 0x20)
        }
    }

    function sub(uint256 x, uint256 y) external pure returns (uint256) {
        assembly {
            // Subtract y from x
            let result := sub(x, y)
            
            // Store result in memory and return
            mstore(0x00, result)
            return(0x00, 0x20)
        }
    }

    function mul(uint256 x, uint256 y) external pure returns (uint256) {
        assembly {
            // Multiply x by y
            let result := mul(x, y)
            
            // Store result in memory and return
            mstore(0x00, result)
            return(0x00, 0x20)
        }
    }

    function div(uint256 x, uint256 y) external pure returns (uint256) {
        assembly {
            // Divide x by y
            let result := div(x, y)
            
            // Store result in memory and return
            mstore(0x00, result)
            return(0x00, 0x20)
        }
    }
}