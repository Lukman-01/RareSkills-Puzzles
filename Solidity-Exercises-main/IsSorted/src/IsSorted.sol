// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract IsSorted {
    /**
     * The goal of this exercise is to return true if the members of "arr" is sorted (in ascending order) or false if its not.
     */
    function isSorted(uint256[] calldata arr) public view returns (bool) {
        // An empty array or a single element array is considered sorted
        if (arr.length < 2) {
            return true;
        }

        // Iterate through the array and compare each element with the next one
        for (uint256 i = 0; i < arr.length - 1; i++) {
            // If the current element is greater than the next element, array is not sorted
            if (arr[i] > arr[i + 1]) {
                return false;
            }
        }

        // If no elements are out of order, the array is sorted
        return true;
    }
}
