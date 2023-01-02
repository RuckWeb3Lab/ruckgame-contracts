import { ethers } from "hardhat";

async function main() {
  const factory = await ethers.getContractFactory("RuckGameNFT")
  const contract = await factory.deploy("RuckGameNFT", "RUCK")

  await contract.deployed()

  console.log("Deployed to:", contract.address)
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
});

