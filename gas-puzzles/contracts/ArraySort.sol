// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.15;

contract OptimizedArraySort {
    function sortArray(uint256[] calldata data) external pure returns (uint256[] memory) {
        uint256 dataLen = data.length;
        
        // Early return for edge cases
        if (dataLen <= 1) {
            uint256[] memory result = new uint256[](dataLen);
            if (dataLen == 1) result[0] = data[0];
            return result;
        }

        // Create working copy efficiently
        uint256[] memory _data = new uint256[](dataLen);
        unchecked {
            for (uint256 k = 0; k < dataLen; ++k) {
                _data[k] = data[k];
            }
        }

        // Optimized bubble sort with gas-efficient loops
        uint256 n = dataLen;
        uint256 i;
        uint256 j;
        
        unchecked {
            for (i = 0; i < n - 1; ++i) {
                for (j = i + 1; j < n; ++j) {
                    if (_data[i] > _data[j]) {
                        // Inline swap without temporary variable
                        assembly {
                            let pos_i := add(add(_data, 0x20), mul(i, 0x20))
                            let pos_j := add(add(_data, 0x20), mul(j, 0x20))
                            let val_i := mload(pos_i)
                            let val_j := mload(pos_j)
                            mstore(pos_i, val_j)
                            mstore(pos_j, val_i)
                        }
                    }
                }
            }
        }

        return _data;
    }
}

     