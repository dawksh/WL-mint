
const hre = require("hardhat");

async function main() {

  const WLMint = await hre.ethers.getContractFactory("WhitelistMint");
  const contract = await WLMint.deploy("Daksh", "DK", ["0x28172273CC1E0395F3473EC6eD062B6fdFb15940", "0x4006c21A130D70000f59e009E4f81DB18eb1Ef00", "0x9F040a259d05d57DBf9d989e561a0456a1f2D681", "0x4587D6f7043454B1b7Ecbc5c26795baDaaa151d3"], "https://gateway.pinata.cloud/ipfs/QmQMtF6RxJEYREduooMrRs18b7BBwkkSdPXLvhdsaqopDp/", "0x9399BB24DBB5C4b782C70c2969F58716Ebbd6a3b");

  await contract.deployed();

  console.log("Greeter deployed to:", contract.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
