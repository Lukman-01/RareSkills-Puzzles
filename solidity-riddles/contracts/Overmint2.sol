// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Overmint2 is ERC721 {
    using Address for address;
    uint256 public totalSupply;

    constructor() ERC721("Overmint2", "AT") {}

    function mint() external {
        require(balanceOf(msg.sender) <= 3, "max 3 NFTs");
        totalSupply++;
        //@audit-issue user can mint upto 3 then transfer to another address and mint again
        _mint(msg.sender, totalSupply);
        //@audit-info Instead of checking balanceOf(msg.sender), maintain a mapping to track how many NFTs an address has minted in total.
    }

    function success() external view returns (bool) {
        return balanceOf(msg.sender) == 5;
    }
}
