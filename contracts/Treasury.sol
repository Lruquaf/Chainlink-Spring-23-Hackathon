// SPDX-License-Identifier: MIT

/**
 * @title Treasury Contract of DAO Governance
 * @author Lruquaf ---> github.com/Lruquaf
 * @notice this contract is a simple treasury, which can
 * transfer the assets to an address by proposals of the governance
 */

pragma solidity ^0.8.8;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./IToken.sol";

contract Treasury is Ownable {
    IToken public token; // address of token currency of the governance
    uint256 public balance; // balance of treasury

    event Transferred(address to, uint256 amount);
    event Received(address from, uint256 amount);

    /**
     *
     * @param _governance address of the governance contract
     * @param _token address of governance token address
     * @notice transfers ownership of this contract to governance contract
     * @notice transfers token vesting funds to this contract from token contract
     */

    constructor(address _governance, address _token) {
        transferOwnership(_governance);
        token = IToken(_token);
        token.withdraw();
    }

    /**
     *
     * @param to destination address of transfer
     * @param amount asset amount of transfer
     * @notice can be called by only governance contract
     */

    function transfer(address to, uint256 amount) public onlyOwner {
        (bool success, ) = to.call{value: amount}("");
        require(success, "Transfer failed!");
        emit Transferred(to, amount);
    }

    /**
     * @notice returns balance of this contract
     */

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    /**
     * @notice can receive ETH for funding
     */

    receive() external payable {
        emit Received(msg.sender, msg.value);
    }
}
