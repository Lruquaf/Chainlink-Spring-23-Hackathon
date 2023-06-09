const {network} = require("hardhat")
const {developmentChains} = require("../helper-hardhat-config")
const {verify} = require("../utils/verify")

module.exports = async ({getNamedAccounts, deployments}) => {
    const {deploy, log} = deployments
    const {deployer} = await getNamedAccounts()

    console.log("Deploying automation contract...")

    const automation = await deploy("Automation", {
        from: deployer,
        args: [],
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    })

    if (
        !developmentChains.includes(network.name) &&
        process.env.SEPOLIA_ETHERSCAN_API_KEY
    ) {
        await verify(automation.address, [])
    }

    console.log("Automation contract was deployed!")
}

module.exports.tags = ["all", "automation"]
