import { ethers } from "hardhat";

async function main() {
  const ruckGameNFTAddress = "0x809Ca6cb69a69BdA7A74Aa0994A39C8c1cdC0863"

  const instance = await ethers.getContractFactory("RuckGameController")
  const contract = await instance.deploy(ruckGameNFTAddress)

  await contract.deployed()

  console.log("Deployed to:", contract.address)
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
});

