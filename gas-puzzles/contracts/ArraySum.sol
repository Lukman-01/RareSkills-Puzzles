// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

contract OptimizedArraySum {
    // Do not modify this
    uint256[] array;

    // Do not modify this
    function setArray(uint256[] memory _array) external {
        require(_array.length <= 10, 'too long');
        array = _array;
    }

    // Function to calculate the sum of elements in the array
    function getArraySum() external view returns (uint256) {
        uint256 sum; // Variable to store the sum of array elements
        uint256 length = array.length; // Get the length of the array and store it in a local variable

        // Loop through each element in the array
        for (uint256 i = 0; i < length; i++) {
            sum += array[i]; // Add the value of each array element to the sum
        }

        return sum; // Return the total sum of the array elements
    }
}
