// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

interface IGovernance {
    struct CurrentProposal {
        uint256 proposalId;
        uint256 executionTime;
        address[] targets;
        uint256[] values;
        bytes[] calldatas;
        bytes32 description;
        string descriptionString;
    }

    function execute(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) external payable returns (uint256);

    function getProposalId() external view returns (uint256);

    function getExecutionTime() external view returns (uint256);

    function getTargets() external view returns (address[] memory);

    function getValues() external view returns (uint256[] memory);

    function getCalldatas() external view returns (bytes[] memory);

    function getDescription() external view returns (bytes32);

    function getDescriptionString() external view returns (string memory);

    function isReadyToExecution() external view returns (bool);
}
