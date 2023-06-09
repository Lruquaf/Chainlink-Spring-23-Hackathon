// SPDX-License-Identifier: MIT

/**
 * @title Automation contract for of execution process for the DAO
 * @author Lruquaf ---> github.com/Lruquaf
 * @notice this Chainlink Automation compatible contract executes
 * a passed and ready proposal in Governance.sol automatically
 */

pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AutomationCompatibleInterface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IGovernance.sol";

contract Automation is AutomationCompatibleInterface, Ownable {
    IGovernance public governance; // address of governance contract

    event UpkeepPerformed(uint256 proposalId, bytes32 descirption);

    /**
     *
     * @param _governance sets governance contract.
     * @notice This function can be accessible by owner of this contract
     */

    function setGovernance(address _governance) public onlyOwner {
        require(
            address(governance) == address(0),
            "Governance contract has already set!"
        );
        governance = IGovernance(_governance);
    }

    /**
     *
     * @param "checkData" is not used
     * @return upkeepNeeded is whether upkeep conditions are fulfilled or not
     * @return performData is not used
     * @notice checks whether the conditions for a proposal to execution are fulfilled or not
     * @dev overrides interface AutomationCompatibleInterface.sol
     */

    function checkUpkeep(
        bytes calldata /* checkData */
    )
        external
        view
        override
        returns (bool upkeepNeeded, bytes memory /* performData */)
    {
        uint256 proposalId = governance.getProposalId();
        uint256 executionTime = governance.getExecutionTime();
        upkeepNeeded =
            (proposalId != 0) &&
            (governance.isReadyToExecution()) &&
            (executionTime <= block.timestamp);
    }

    /**
     *
     * @param "performdata" is not used
     * @dev overrides interface AutomationCompatibleInterface.sol
     * @notice performs the execution of current proposal
     */

    function performUpkeep(bytes calldata /* performData */) external override {
        uint256 proposalId = governance.getProposalId();
        uint256 executionTime = governance.getExecutionTime();
        require(
            (proposalId != 0) &&
                (executionTime <= block.timestamp) &&
                (governance.isReadyToExecution()),
            "Execution is not ready yet!"
        );
        governance.execute(
            governance.getTargets(),
            governance.getValues(),
            governance.getCalldatas(),
            governance.getDescription()
        );
        emit UpkeepPerformed(proposalId, governance.getDescription());
    }
}
