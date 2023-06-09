const {network} = require("hardhat")
const {developmentChains} = require("../helper-hardhat-config")
const {verify} = require("../utils/verify")

module.exports = async ({getNamedAccounts, deployments}) => {
    const {deploy, log} = deployments
    const {deployer} = await getNamedAccounts()

    const token = await ethers.getContract("Token")
    const automation = await ethers.getContract("Automation")

    const args = [token.address, automation.address]

    console.log("Deploying governance contract...")

    const governance = await deploy("Governance", {
        from: deployer,
        args: args,
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    })

    if (
        !developmentChains.includes(network.name) &&
        process.env.SEPOLIA_ETHERSCAN_API_KEY
    ) {
        await verify(governance.address, args)
    }

    console.log("Governance contract was deployed!")
}

module.exports.tags = ["all", "governance"]
