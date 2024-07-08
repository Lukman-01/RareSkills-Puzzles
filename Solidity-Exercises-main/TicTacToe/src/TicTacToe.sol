// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract TicTacToe {
    /* 
        This exercise assumes you know how to manipulate nested array.
        1. This contract checks if TicTacToe board is winning or not.
        2. Write your code in `isWinning` function that returns true if a board is winning
           or false if not.
        3. Board contains 1's and 0's elements and it is also a 3x3 nested array.
    */

    /**
     * This function checks if the TicTacToe board is in a winning state.
     * @param board A 3x3 nested array representing the TicTacToe board.
     * @return true if the board is in a winning state, false otherwise.
     */
    function isWinning(uint8[3][3] memory board) public pure returns (bool) {
        // Check each row for a winning condition
        for (uint8 i = 0; i < 3; i++) {
            // If all elements in a row are equal to 1, return true
            if (board[i][0] == board[i][1] && board[i][1] == board[i][2] && board[i][0] == 1) {
                return true;
            }
        }
        
        // Check each column for a winning condition
        for (uint8 j = 0; j < 3; j++) {
            // If all elements in a column are equal to 1, return true
            if (board[0][j] == board[1][j] && board[1][j] == board[2][j] && board[0][j] == 1) {
                return true;
            }
        }

        // Check the first diagonal (top-left to bottom-right) for a winning condition
        if (board[0][0] == board[1][1] && board[1][1] == board[2][2] && board[0][0] == 1) {
            return true;
        }
        // Check the second diagonal (top-right to bottom-left) for a winning condition
        if (board[0][2] == board[1][1] && board[1][1] == board[2][0] && board[0][2] == 1) {
            return true;
        }

        // If no winning condition is met, return false
        return false;
    }
}
