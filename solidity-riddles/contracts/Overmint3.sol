// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Overmint3 is ERC721 {
    using Address for address;
    mapping(address => uint256) public amountMinted;
    uint256 public totalSupply;

    constructor() ERC721("Overmint3", "AT") {}

    function mint() external {
        //@audit-issue If the contract does not check tx.origin, and allows calls from a proxy, then a low-level call can sometimes bypass the contract check.
        //@audit-info 'isContract() can also be bypassed using constructor'
        require(!msg.sender.isContract(), "no contracts");
        require(amountMinted[msg.sender] < 1, "only 1 NFT");
        totalSupply++;
        _safeMint(msg.sender, totalSupply);
        amountMinted[msg.sender]++;
        //@audit-info To prevent low-level call spoofing via proxy contracts, enforce that `msg.sender` must be equal to `tx.origin`, ensuring only EOAs can call `mint()`. However, this approach also blocks legitimate meta-transactions from relayers.
    }
}
