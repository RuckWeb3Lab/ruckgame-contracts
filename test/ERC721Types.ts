import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
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

    return {
      owner,
      account1,
      account2,
      ruckGameNFT,
      erc721Types
    }
  }

  describe("getType", function () {
    it("タイプが取得できること", async function () {
      const { ruckGameNFT, erc721Types } = await loadFixture(contractFixture)

      const nftTypes = await erc721Types.getType(ruckGameNFT.address, 1);
      console.log(nftTypes);

      expect(nftTypes['firstType']).to.equal(11);
      expect(nftTypes['firstTypeName']).to.equal('psycho');
      expect(nftTypes['secondType']).to.equal(15);
      expect(nftTypes['secondTypeName']).to.equal('dragon');
    });
  });
})
