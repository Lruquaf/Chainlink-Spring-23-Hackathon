const {ethers} = require("hardhat")

const networkConfig = {
    11155111: {
        name: "sepolia",
    },
    80001: {
        name: "mumbai",
    },
}

const PARAM_TO = "0xC85C392654B161E9a16f8f8766Db5E75620dD276"
const PARAM_AMOUNT = ethers.utils.parseEther("0.1")
const FUNC = "transfer"
const PROPOSAL_DESCRIPTION = `Proposal #0: ${FUNC} ${PARAM_AMOUNT} amount of funds to ${PARAM_TO}!`
const VOTING_DELAY = 1 // blocks
const VOTING_PERIOD = 10 // blocks

const developmentChains = ["hardhat", "localhost"]

module.exports = {
    networkConfig,
    developmentChains,
    PARAM_TO,
    PARAM_AMOUNT,
    FUNC,
    PROPOSAL_DESCRIPTION,
    VOTING_DELAY,
    VOTING_PERIOD,
}
