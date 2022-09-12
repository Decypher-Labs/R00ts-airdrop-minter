require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

const RPC_URL = process.env.RPC_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.9",
  networks: {
      goerli: {
        url: RPC_URL, //TODO get from env
        accounts: [
          PRIVATE_KEY, //TODO get from env
        ],
      },
    },
};
