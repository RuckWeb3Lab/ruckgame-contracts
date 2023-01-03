import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { ethers } from "hardhat";

describe('ERC721Types', () => {
  const contractFixture = async () => {
    const [
      owner,
      account1,
      account2
    ] = await ethers.getSigners();

    const RuckGameNFT = await ethers.getContractFactory("RuckGameNFT");
    const ruckGameNFT = await RuckGameNFT.deploy("RuckGameNFT", "RUCK");

    const ERC721Types = await ethers.getContractFactory("ERC721Types");
    const erc721Types = await ERC721Types.deploy();

    await erc721Types.includeERC721(ruckGameNFT.address);

    return {
      owner,
      account1,
      account2,
      ruckGameNFT,
      erc721Types
    }
  }

  describe("baseURI", function () {
    it("baseURIが取得できること。", async function () {
      const { ruckGameNFT, erc721Types } = await loadFixture(contractFixture)

      const test = await erc721Types.getType(ruckGameNFT.address, 221);
      console.log(Number(test))

      // expect(await contracts.baseURI()).to.equal(NFT_BASE_URI);
    });
  });
})
