require("@nomicfoundation/hardhat-toolbox")
require("hardhat-deploy")
require("dotenv").config()

const PRIVATE_KEY = process.env.PRIVATE_KEY || "0xkey"
const TEST_1_KEY = process.env.TEST_1_KEY || "0xkey"
const TEST_2_KEY = process.env.TEST_2_KEY || "0xkey"
const TEST_3_KEY = process.env.TEST_3_KEY || "0xkey"
const SEPOLIA_RPC_URL = process.env.SEPOLIA_RPC_URL || "https://sepolia"
const SEPOLIA_ETHERSCAN_API_KEY = process.env.SEPOLIA_ETHERSCAN_API_KEY || "key"
const MUMBAI_RPC_URL = process.env.MUMBAI_RPC_URL || "https://mumbai"
const POLYGONSCAN_API_KEY = process.env.POLYGONSCAN_API_KEY || "key"

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
    solidity: {
        version: "0.8.18",
        settings: {
            optimizer: {
                enabled: true,
                runs: 99999,
                details: {yul: false},
            },
        },
    },
    defaultNetwork: "hardhat",
    networks: {
        hardhat: {
            chainId: 31337,
            blockConfirmations: 1,
            allowUnlimitedContractSize: true,
        },
        sepolia: {
            chainId: 11155111,
            blockConfirmations: 6,
            url: SEPOLIA_RPC_URL,
            accounts: [PRIVATE_KEY, TEST_1_KEY, TEST_2_KEY, TEST_3_KEY],
        },
        mumbai: {
            chainId: 80001,
            blockConfirmations: 6,
            url: MUMBAI_RPC_URL,
            accounts: [PRIVATE_KEY, TEST_1_KEY, TEST_2_KEY, TEST_3_KEY],
        },
    },
    etherscan: {
        apiKey: {
            sepolia: SEPOLIA_ETHERSCAN_API_KEY,
            polygonMumbai: POLYGONSCAN_API_KEY,
        },
    },
    namedAccounts: {
        deployer: {
            default: 0,
            sepolia: 0,
            mumbai: 0,
        },
        user1: {
            default: 1,
            sepolia: 1,
            mumbai: 1,
        },
        user2: {
            default: 2,
            sepolia: 2,
            mumbai: 2,
        },
        user3: {
            default: 3,
            sepolia: 3,
            mumbai: 3,
        },
    },
}
