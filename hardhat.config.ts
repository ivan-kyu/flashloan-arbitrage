import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import dotenv from "dotenv";
dotenv.config();

const config: HardhatUserConfig = {
  solidity: "0.8.10",
  networks: {
    sepolia: {
      url: process.env.INFURA_ENDPOINT,
      accounts: [process.env.PRIVATE_KEY!],
    }
  }
};

export default config;