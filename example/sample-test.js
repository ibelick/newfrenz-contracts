const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("NewFrenz", function () {
  it("Should return the new greeting once it's changed", async function () {
    const nftContractFactory = await ethers.getContractFactory("NewFrenz");
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();

    expect(await greeter.greet()).to.equal("Hello, world!");

    const setGreetingTx = await greeter.setGreeting("Hola, mundo!");
    await setGreetingTx.wait();

    expect(await greeter.greet()).to.equal("Hola, mundo!");
  });
});
