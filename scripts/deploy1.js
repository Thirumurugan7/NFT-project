// scripts/interact.js
const { ethers } = require("hardhat");
const contractABI = require("../artifacts/onChainNFT.sol/OnChainNFT.json");
const main = async () => {
  // Replace 'YourContractAddress' with the actual address of the deployed contract
  const contractAddress = "YourContractAddress";
  
  // Replace 'YourContractABI' with the actual ABI of the deployed contract
  const contractABI = YourContractABI;

  // Connect to the deployed contract
  const nftContract = new ethers.Contract(contractAddress, contractABI, ethers.provider);

  // Call the mint function from the contract
  const txn = await nftContract.mint();
  const txnReceipt = await txn.wait();

  // Get the token id of the minted NFT (using our event)
  const event = txnReceipt.events?.find((event) => event.event === "Minted");
  const tokenId = event?.args["tokenId"];

  console.log(
    "🎨 Your minted NFT:",
    `https://testnets.opensea.io/assets/${contractAddress}/${tokenId}`
  );
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
