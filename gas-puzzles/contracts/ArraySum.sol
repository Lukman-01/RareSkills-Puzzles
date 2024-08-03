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

    /*
    // Original unoptimized function
    function getArraySum() external view returns (uint256) {
        uint256 sum;
        for (uint256 i = 0; i < array.length; i++) {
            sum += array[i];
        }

        return sum;
    }
    */

    // Optimized function using a do-while loop
    function getArraySum() external view returns (uint256) {
        uint256 sum;
        uint256 length = array.length;

        if (length == 0) {
            return 0;
        }

        uint256 i;

        do {
            sum += array[i];
            unchecked { ++i; }
        } while (i < length);

        return sum;
    }

    /*
    Explanation:
    - Local Variable for Length: By storing the array length in a local variable `length`, 
      we avoid repeated storage reads, which are more expensive in terms of gas.
    - Initial Length Check: If the array is empty (`length == 0`), we return 0 immediately 
      to avoid unnecessary looping.
    - `do-while` Loop: A `do-while` loop is used instead of a `for` loop. This loop guarantees 
      at least one iteration, which can be more gas-efficient in scenarios where the loop executes 
      at least once. The `unchecked` block is used for the increment operation to save gas by 
      skipping overflow checks (safe in this context as `i` will not exceed `length`).

    These changes reduce the gas consumption by minimizing storage reads and utilizing a slightly 
    more efficient looping construct.
    */
}
