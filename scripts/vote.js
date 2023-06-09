const {ethers, getNamedAccounts} = require("hardhat")
const {VOTING_PERIOD, developmentChains} = require("../helper-hardhat-config")
const {moveBlocks} = require("../utils/move-blocks")

async function main() {
    console.log("Voting...")

    const {deployer} = await getNamedAccounts()
    const {user1} = await getNamedAccounts()
    const {user2} = await getNamedAccounts()
    const {user3} = await getNamedAccounts()

    const governance = await ethers.getContract("Governance")

    await vote(deployer, 1)
    // await vote(user1, 0)
    // await vote(user2, 1)
    // await vote(user3, 1)

    if (developmentChains.includes(network.name)) {
        await moveBlocks(VOTING_PERIOD + 1)
    }

    // const proposalId = await governance.getProposalId()
    // const state = await governance.state(proposalId)

    // console.log(`Proposal State: ${state}`)

    console.log("Voted! Ready to execute!")
}

async function vote(signer, voteWay) {
    const governance = await ethers.getContract("Governance", signer)
    const currentProposal = await governance.currentProposal()
    const proposalId = currentProposal.proposalId.toString()
    // console.log(proposalId)
    // 0 = Against, 1 = For, 2 = Abstain
    const reason = "My vote is my life and honor!"
    const voteTxResponse = await governance.castVoteWithReason(
        proposalId,
        voteWay,
        reason
    )
    await voteTxResponse.wait(1)
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
