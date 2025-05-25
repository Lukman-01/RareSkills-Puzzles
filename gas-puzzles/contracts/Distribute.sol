// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

contract OptimizedDistribute {
    address[4] public contributors;
    uint256 public createTime;

    constructor(address[4] memory _contributors) payable {
        contributors = _contributors;
        createTime = block.timestamp;
    }

    function distribute() external {
        unchecked {
            require(
                block.timestamp > createTime + 604800, // 1 week in seconds
                "cannot distribute yet"
            );

            uint256 balance = address(this).balance;
            uint256 amount = balance >> 2; // Division by 4 using bit shift
            
            // Cache contributors to avoid repeated SLOAD operations
            address[4] memory _contributors = contributors;
            
            // Use call instead of transfer for gas efficiency
            assembly {
                let success := call(gas(), mload(add(_contributors, 0x00)), amount, 0, 0, 0, 0)
                if iszero(success) { revert(0, 0) }
                
                success := call(gas(), mload(add(_contributors, 0x20)), amount, 0, 0, 0, 0)
                if iszero(success) { revert(0, 0) }
                
                success := call(gas(), mload(add(_contributors, 0x40)), amount, 0, 0, 0, 0)
                if iszero(success) { revert(0, 0) }
                
                success := call(gas(), mload(add(_contributors, 0x60)), amount, 0, 0, 0, 0)
                if iszero(success) { revert(0, 0) }
            }
        }
    }
}