const {ethers} = require("hardhat")
const {
    PARAM_TO,
    PARAM_AMOUNT,
    FUNC,
    PROPOSAL_DESCRIPTION,
    developmentChains,
    VOTING_DELAY,
} = require("../helper-hardhat-config")
const {moveBlocks} = require("../utils/move-blocks")

async function main() {
    const governance = await ethers.getContract("Governance")
    const treasury = await ethers.getContract("Treasury")
    const args = [PARAM_TO, PARAM_AMOUNT]
    const value = ethers.utils.parseEther("0")
    const functionToCall = FUNC
    const proposalDescription = PROPOSAL_DESCRIPTION
    const encodedFunctionCall = treasury.interface.encodeFunctionData(
        functionToCall,
        args
    )
    console.log(
        `Proposing ${functionToCall} on ${treasury.address} with ${args}`
    )

    console.log(encodedFunctionCall)

    console.log(`Proposal Description:\n${proposalDescription}`)

    const proposeTx = await governance.propose(
        [treasury.address],
        [value],
        [encodedFunctionCall],
        proposalDescription
    )

    if (developmentChains.includes(network.name)) {
        await moveBlocks(VOTING_DELAY + 1)
    }

    await proposeTx.wait(1)

    // const proposalId = await governance.getProposalId()
    // console.log(`Prposal id: ${proposalId}`)
    // const snapshot = await governance.proposalSnapshot(proposalId)
    // const deadline = await governance.proposalDeadline(proposalId)
    // console.log(
    //     `Proposal Snapshot: ${snapshot}\nProposal Deadline: ${deadline}`
    // )
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
