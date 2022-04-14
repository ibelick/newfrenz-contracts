const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("NewFrenz", function () {
  it("Should return the new greeting once it's changed", async function () {
    const nftContractFactory = await ethers.getContractFactory("NewFrenz");
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log("Contract deployed to:", nftContract.address);

    let txn = await nftContract.create("ibelick");
    await txn.wait();
    console.log("Minted NFT #1");

    txn = await nftContract.create("aaaaaaaaaaaaaaa");
    await txn.wait();
    console.log("Minted NFT #2");
  });
});
