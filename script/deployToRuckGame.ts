import { ethers } from "hardhat";

async function main() {
  const ruckGameNFTAddress = "0x6Bc07B56e1970F30FA701a936A8D08DF81dD15C4"

  const instance = await ethers.getContractFactory("RuckGameController")
  const contract = await instance.deploy(ruckGameNFTAddress)

  await contract.deployed()

  console.log("Deployed to:", contract.address)
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
});

