import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomiclabs/hardhat-etherscan";
import * as dotenv from 'dotenv';
dotenv.config();

const ALCHEMY_API_KEY = process.env.ALCHEMY_API_KEY ?? '';
const GOERLI_PRIVATE_KEY = process.env.GOERLI_PRIVATE_KEY ?? '';

/** @type import('hardhat/config').HardhatUserConfig */
const config: HardhatUserConfig = {
  networks: {
    goerli: {
      url: `https://eth-goerli.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      accounts: [GOERLI_PRIVATE_KEY],
    }
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY
  },
  solidity: {
    version: "0.8.17"
  }
};

export default config;
