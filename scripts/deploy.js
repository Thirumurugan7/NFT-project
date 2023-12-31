// scripts/deploy.js
const main = async () => {
  // Get 'OnChainNFT' contract
  const nftContractFactory = await hre.ethers.getContractFactory("OnChainNFT");

  // Set the number of NFTs to mint
  const numberOfNFTs = 2; // Set the desired number of NFTs to mint

  // Calculate the mint price for a single NFT in ether
  const mintPrice = ethers.utils.parseEther('0.0069');

  // Calculate the total value to send for the specified number of NFTs
  const totalValue = mintPrice.mul(numberOfNFTs);

  // Deploy contract
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log("✅ Contract deployed to:", nftContract.address);




  // // Call the mint function from our contract
  // const txn = await nftContract.mint();
  // const txnReceipt = await txn.wait();

  // // Get the token id of the minted NFT (using our event)
  // const event = txnReceipt.events?.find((event) => event.event === "Minted");
  // const tokenId = event?.args["tokenId"];

  // console.log(
  //   "🎨 Your minted NFT:",
  //   `https://testnets.opensea.io/assets/${nftContract.address}/${tokenId}`
  // );


    // Specify a higher gas limit (adjust the value accordingly)
    // const gasLimit = 300000000; // Set your desired gas limit

    const estimatedGas = await nftContract.estimateGas.mint(numberOfNFTs, { value: totalValue });
    const gasLimit = estimatedGas.mul(2); // You can adjust the multiplier as needed

    // Mint NFTs by sending the exact amount with a higher gas limit
    const mintTx = await nftContract.mint(numberOfNFTs, {
      value: totalValue
    });
    await mintTx.wait();

    console.log(`Minted ${numberOfNFTs} NFTs successfully!`);

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
