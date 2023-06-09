const {ethers, network} = require("hardhat")
const {developmentChains} = require("../helper-hardhat-config")
const {moveTime} = require("../utils/move-time")
const {moveBlocks} = require("../utils/move-blocks")

async function main() {
    const governance = await ethers.getContract("Governance")
    const automation = await ethers.getContract("Automation")
    const treasury = await ethers.getContract("Treasury")
    const executionDelay = await governance.executionDelay()

    // const setGovTx = await automation.setGovernance(governance.address)
    // await setGovTx.wait(1)

    const balance = await treasury.getBalance()
    console.log(`Treasury balance: ${balance}`)

    if (developmentChains.includes(network.name)) {
        await moveTime(parseInt(executionDelay.toString()))
        await moveBlocks(1)
    }

    const proposalId = await governance.getProposalId()
    const snapshot = await governance.proposalSnapshot(proposalId)
    console.log(`Snapshot: ${snapshot}`)
    const state = await governance.state(proposalId)
    console.log(`Proposal State: ${state}`)

    console.log("Executing...")

    const executeTx = await automation.performUpkeep("0x00", {
        gasLimit: 10000000,
    })
    await executeTx.wait(1)

    console.log(`Treasury balance: ${balance}`)
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
