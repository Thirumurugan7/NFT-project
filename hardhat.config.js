/**
 * @type import('hardhat/config').HardhatUserConfig
 */
require("dotenv").config();
require("@nomiclabs/hardhat-ethers");
require("@nomicfoundation/hardhat-verify");

const { API_URL, PRIVATE_KEY } = process.env;

module.exports = {
  solidity: "0.8.22",
  defaultNetwork: "polygon_mumbai",
  networks: {
    hardhat: {},
    polygon_mumbai: {
      url: API_URL,
      accounts: [`0x${PRIVATE_KEY}`],
    },
    sepolia:{
      url:API_URL,
      accounts: [`0x${PRIVATE_KEY}`],
    }
  },
  etherscan:{
    apiKey:'EBA8HK7X6JFJ34G4NJCUPFBNA1DERR2BTE'
  },
  sourcify: {
    enabled: false
  }
  

};
