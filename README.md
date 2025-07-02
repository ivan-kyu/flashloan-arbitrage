# AAVE FlashLoan Arbitrage Hardhat Project

This project demonstrates a basic flashloan arbitrage capabilities using Aave.
It consists of FlashLoanArbitrage contract which gets the flashloan and executes the arbitrage agains a dummy DEX contract

## Environment Setup

Before running the project, you need to set up your environment variables:

1. Copy the `.env.example` file to `.env`:
   ```shell
   cp .env.example .env
   ```

2. Fill in the required environment variables in `.env`:
   - `INFURA_ENDPOINT`: Your Infura endpoint URL for Sepolia network (e.g., `https://sepolia.infura.io/v3/YOUR_PROJECT_ID`)
   - `PRIVATE_KEY`: Your wallet's private key for deploying contracts (without 0x prefix)

⚠️ **Important**: Never commit your `.env` file with real private keys to version control!

## Running the Project

Try running some of the following tasks:

```shell
npm install

npm run deploy-contracts-testnet
```

Sepolia AAVE USDC=0xda9d4f9b69ac6C22e444eD9aF0CfC043b7a7f53f
Sepolia AAVE DAI=0x68194a729C2450ad26072b3D33ADaCbcef39D574

Sepolia AAVE Faucet=https://staging.aave.com/faucet/
