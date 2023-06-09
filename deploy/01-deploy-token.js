const {network, ethers} = require("hardhat")
const {developmentChains} = require("../helper-hardhat-config")
const {verify} = require("../utils/verify")

module.exports = async ({getNamedAccounts, deployments}) => {
    const {deploy, log} = deployments
    const {deployer} = await getNamedAccounts()
    const tokenPrice = ethers.utils.parseEther("0.1")

    const {user1} = await getNamedAccounts()
    const {user2} = await getNamedAccounts()
    const {user3} = await getNamedAccounts()

    console.log("Deploying token contract...")

    const token = await deploy("Token", {
        from: deployer,
        args: [],
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    })

    if (
        !developmentChains.includes(network.name) &&
        process.env.SEPOLIA_ETHERSCAN_API_KEY
    ) {
        await verify(token.address, [])
    }
    console.log("Token contract was deployed!")

    // console.log("Minting tokens...")
    // await mint(deployer, tokenPrice)
    // // await mint(user1, tokenPrice)
    // // await mint(user2, tokenPrice)
    // // await mint(user3, tokenPrice)
    // console.log("Tokens minted!")

    console.log("Delegating...")
    await delegate(deployer)
    // await delegate(user1)
    // await delegate(user2)
    // await delegate(user3)
    console.log("Delegated!")
}

const mint = async (signer, tokenPrice) => {
    const token = await ethers.getContract("Token", signer)
    const tx = await token.mint({value: tokenPrice})
    await tx.wait(1)
}

const delegate = async (delegatedAccount) => {
    const token = await ethers.getContract("Token")
    const tx = await token.delegate(delegatedAccount)
    await tx.wait(1)
    console.log(`Checkpoints ${await token.numCheckpoints(delegatedAccount)}`)
}

module.exports.tags = ["all", "token"]
