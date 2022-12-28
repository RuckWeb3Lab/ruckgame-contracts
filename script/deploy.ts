import { ethers } from "hardhat";

async function main() {
  const RepDogsNFT = await ethers.getContractFactory("RepDogsNFT")
  const contractt = await RepDogsNFT.deploy("RepDogsNFT", "RDNFT", "http://localhost")

  await contractt.deployed()

  console.log("Deployed to:", contractt.address)
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
});

