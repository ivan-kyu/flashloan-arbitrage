import { ethers } from "hardhat";

async function main() {

  const daiAddress = "0x68194a729C2450ad26072b3D33ADaCbcef39D574";
  const usdcAddress = "0xda9d4f9b69ac6C22e444eD9aF0CfC043b7a7f53f";
  const aavePoolAddressesProviderContract = "0x0496275d34753A48320CA58103d5220d394FF77F";

  const Dex = await ethers.getContractFactory("Dex");
  const dex = await Dex.deploy(daiAddress, usdcAddress);
  await dex.deployed();
  console.log(`DEX Address: ${dex.address}`);

  const FlashLoanArbitrage = await ethers.getContractFactory("FlashLoanArbitrage");
  const flashLoanArbitrage = await FlashLoanArbitrage
    .deploy(
      aavePoolAddressesProviderContract, 
      dex.address,
      daiAddress,
      usdcAddress
    );

  await flashLoanArbitrage.deployed();
  console.log(`FlashLoanArbitrage Address: ${flashLoanArbitrage.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
