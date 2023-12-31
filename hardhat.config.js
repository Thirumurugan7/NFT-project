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
    apiKey:'PJSQNQFA1MT1ZG5HJGVU15NSKJQATA9QKM'
  },
  sourcify: {
    enabled: false
  }
  

};
