// SPDX-License-Identifier: MIT

/**
 * @title Governance Contract of DAO
 * @author Lruquaf ---> github.com/Lruquaf && Alsond6 ---> github.com/Alsond6
 * @notice Members of DAO can create a proposal and vote it.
 * If it pass, then it is executed by automation contract automatically
 */

pragma solidity ^0.8.9;

import "./IGovernance.sol";
import "@openzeppelin/contracts/governance/Governor.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";

contract Governance is
    IGovernance,
    Governor,
    GovernorCountingSimple,
    GovernorVotes,
    GovernorVotesQuorumFraction
{
    address public automation; // address of automation contract

    CurrentProposal public currentProposal; // active proposal struct

    uint256 public executionDelay = 1 minutes; // time to execute a passed proposal

    /**
     *
     * @param _token address of governace token contract
     * @param _automation address of automation contract
     */

    constructor(
        IVotes _token,
        address _automation
    )
        Governor("Governance")
        GovernorVotes(_token)
        GovernorVotesQuorumFraction(4)
    {
        automation = _automation;
    }

    /**
     *
     * @notice modifier, that only automation contract can valid
     */

    modifier onlyAutomation() {
        require(msg.sender == automation, "Only automation can access!");
        _;
    }

    /**
     *
     * @param _automation sets automation contract. Only governance can access this function
     */

    function setAutomation(address _automation) public {
        require(msg.sender == address(this), "Only governance can access!");
        automation = _automation;
    }

    /**
     * @return returns time delay between creating proposal start of voting period
     */
    function votingDelay() public pure override returns (uint256) {
        return 1; // 1 block
    }

    /**
     * @return returns voting period time
     */
    function votingPeriod() public pure override returns (uint256) {
        return 10; // 10 block
    }

    /**
     *
     * @param targets addresses of interaction process in the proposal
     * @param values ETH values of interaction process in the proposal
     * @param calldatas functions to call of interaction process in the proposal
     * @param description description of proposal
     * @notice create a proposal with these inputs. It requires that the state
     * of former proposal should available for a new proposal. Current proposal
     * is saved on storage to retrieve.
     * @dev overrides parent contract Governor.sol
     * @return proposalId
     */

    function propose(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        string memory description
    ) public override returns (uint256) {
        if (currentProposal.proposalId != 0) {
            require(isReadyToPropose());
        }

        currentProposal.proposalId = super.propose(
            targets,
            values,
            calldatas,
            description
        );
        currentProposal.targets = targets;
        currentProposal.values = values;
        currentProposal.calldatas = calldatas;
        currentProposal.description = keccak256(bytes(description));
        currentProposal.descriptionString = description;
        currentProposal.executionTime =
            block.timestamp +
            165 seconds +
            executionDelay;

        return currentProposal.proposalId;
    }

    /**
     *
     * @param targets addresses of interaction process in the proposal
     * @param values ETH values of interaction process in the proposal
     * @param calldatas functions to call of interaction process in the proposal
     * @param descriptionHash description of proposal
     * @notice cancel a proposal with these inputs. Inputs are controlled.
     * If proposal is valid, it is cancelled and current proposal is deleted.
     * @dev overrides parent contract Governor.sol
     */

    function cancel(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) public {
        require(
            currentProposal.proposalId ==
                hashProposal(targets, values, calldatas, descriptionHash),
            "Unknown proposal!"
        );
        _cancel(targets, values, calldatas, descriptionHash);
        delete currentProposal;
    }

    /**
     *
     * @param targets addresses of interaction process in the proposal
     * @param values ETH values of interaction process in the proposal
     * @param calldatas functions to call of interaction process in the proposal
     * @param descriptionHash description of proposal
     * @notice execute a proposal with these inputs. This function
     * can be called by only Automation contract.
     * @dev overrides parent contract Governor.sol and interface IGovernance.sol
     * @return proposalId
     */

    function execute(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    )
        public
        payable
        override(IGovernance, Governor)
        onlyAutomation
        returns (uint256)
    {
        return super.execute(targets, values, calldatas, descriptionHash);
    }

    /**
     * @return propsalId of current proposal
     */
    function getProposalId() public view returns (uint256) {
        return currentProposal.proposalId;
    }

    /**
     * @return execution time of current proposal
     */
    function getExecutionTime() public view returns (uint256) {
        return currentProposal.executionTime;
    }

    /**
     * @return targets of current proposal
     */
    function getTargets() public view returns (address[] memory) {
        return currentProposal.targets;
    }

    /**
     * @return values of current proposal
     */
    function getValues() public view returns (uint256[] memory) {
        return currentProposal.values;
    }

    /**
     * @return calldatas of current proposal
     */
    function getCalldatas() public view returns (bytes[] memory) {
        return currentProposal.calldatas;
    }

    /**
     * @return description of current proposal
     */
    function getDescription() public view returns (bytes32) {
        return currentProposal.description;
    }

    /**
     * @return description as string of current proposal
     */
    function getDescriptionString() public view returns (string memory) {
        return currentProposal.descriptionString;
    }

    /**
     * @return whether the proposal is ready to execution or not
     */

    function isReadyToExecution() public view returns (bool) {
        return
            (state(currentProposal.proposalId) == ProposalState.Succeeded) ||
            (state(currentProposal.proposalId) == ProposalState.Queued);
    }

    /**
     * @return whether a new proposal is ready to propose or not
     */

    function isReadyToPropose() public view returns (bool) {
        return (state(currentProposal.proposalId) == ProposalState.Canceled ||
            state(currentProposal.proposalId) == ProposalState.Defeated ||
            state(currentProposal.proposalId) == ProposalState.Executed ||
            state(currentProposal.proposalId) == ProposalState.Pending);
    }

    // The following functions are overrides required by Solidity.

    function quorum(
        uint256 blockNumber
    )
        public
        view
        override(IGovernor, GovernorVotesQuorumFraction)
        returns (uint256)
    {
        return super.quorum(blockNumber);
    }
}
