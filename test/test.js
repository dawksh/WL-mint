const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Greeter", function () {
  it("Should return the new greeting once it's changed", async function () {
    const WLContract = await ethers.getContractFactory("WhitelistMint");
    const contract = await WLContract.deploy("Hello, world!");
    await contract.deployed();

    expect(await contract.maxSupply().toString()).to.equal("3000");

  });
});
