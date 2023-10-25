require("@nomicfoundation/hardhat-toolbox");
const dotenv = require("dotenv")

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.19",
  networks: {
    base: {
      url: process.env.BASE_TESTNET,
      accounts: process.env.PRIVATE_KEY,
    }
  }
};
