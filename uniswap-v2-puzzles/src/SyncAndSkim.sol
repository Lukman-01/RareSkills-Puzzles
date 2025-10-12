// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IUniswapV2Pair.sol";

contract Sync {
    /**
     *  SYNC EXERCISE
     *
     *  AMPL token had a negative rebase, meaning there was reduction in supply by adjusting the
     *  balance among all holders including ETH/AMPL pool, allowing trades to receive sub-optimal rates.
     *  The challenge is to force reserves to match the current balances in the ETH/AMPL pool.
     *
     */
    function performSync(address pool) public {
        // Call sync to update reserves to match current balances
        IUniswapV2Pair(pool).sync();
    }
}

contract Skim {
    /**
     *  SKIM EXERCISE
     *
     *  AMPL token had a positive rebase, meaning there was addition in supply by adjusting the
     *  balance among all holders including ETH/AMPL pool. Due to this addition, the pool balance
     *  overflows uint112 storage slot for reserves.
     *  The challange is to rectify this by forcing balances to match the reserves and sending the
     *  difference to this contract.
     *
     */
    function performSkim(address pool) public {
        // Call skim to send excess tokens (difference between balance and reserves) to this contract
        IUniswapV2Pair(pool).skim(address(this));
    }
}
