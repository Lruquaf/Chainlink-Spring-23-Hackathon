const {network} = require("hardhat")
const {developmentChains} = require("../helper-hardhat-config")
const {verify} = require("../utils/verify")

module.exports = async ({getNamedAccounts, deployments}) => {
    const {deploy, log} = deployments
    const {deployer} = await getNamedAccounts()

    const governance = await ethers.getContract("Governance")
    const token = await ethers.getContract("Token")

    const args = [governance.address, token.address]

    console.log("Deploying treasury contract...")

    const treasury = await deploy("Treasury", {
        from: deployer,
        args: args,
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    })

    if (
        !developmentChains.includes(network.name) &&
        process.env.SEPOLIA_ETHERSCAN_API_KEY
    ) {
        await verify(treasury.address, args)
    }

    console.log("Treasury contract was deployed!")
}

module.exports.tags = ["all", "treasury"]
