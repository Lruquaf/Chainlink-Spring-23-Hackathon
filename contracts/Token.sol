// SPDX-License-Identifier: MIT

/**
 * @title Governance token contract
 * @author Lruquaf ---> github.com/Lruquaf
 * @notice this contract is governance token contract with a simple token vesting functionality.
 * This vesting is for testing the DAO and showing a demo for hackathon. Therefore it includes even
 * critical security risks. It is not available for mainnet launch.
 */

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "./IToken.sol";

contract Token is IToken, ERC20Votes {
    uint256 public maxSupply = 10 ** 24; // maximum token supply

    constructor()
        ERC20("GovernanceToken", "GT")
        ERC20Permit("GovernanceToken")
    {}

    /**
     * @notice mints a certain amounts of tokens for a certain amount of ETH
     * this vesting was edited for 4 DAO members. This function includes logic
     * error for token vesting on mainnet.
     */

    function mint() public payable {
        require(msg.value == 0.1 ether, "Not enough ETH!");
        _mint(msg.sender, maxSupply);
    }

    /**
     * @notice withdraws assets to msg.sender. This function includes critical
     * level issue. In testing and demo assets were withdrawn by tresury
     * contract of DAO when it is constructing.
     */

    function withdraw() external {
        payable(msg.sender).transfer(address(this).balance);
    }

    // The functions below are overrides required by Solidity.

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20Votes) {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount) internal override(ERC20Votes) {
        super._mint(to, amount);
    }

    function _burn(
        address account,
        uint256 amount
    ) internal override(ERC20Votes) {
        super._burn(account, amount);
    }
}
