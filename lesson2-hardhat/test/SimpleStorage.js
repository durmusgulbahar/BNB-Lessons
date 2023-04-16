const { expect } = require("chai");
const hre = require("hardhat");


describe("SimpleStorage", function () {
  it("stored data must be 10", async function () {
    

    const simpleStorage = await hre.ethers.getContractFactory("SimpleStorage");
    const storage = await simpleStorage.deploy();
    await storage.deployed();

    await storage.set(10);

    const storedData = await storage.get();

    expect(storedData).to.equal(10);

  });

  it("stored data must be not 20", async function() {

    const simpleStorage = await hre.ethers.getContractFactory("SimpleStorage");
    const storage = await simpleStorage.deploy();
    await storage.deployed();

    await storage.set(3000);

    const storedData = await storage.get();

    expect(storedData).not.equal(20);

  })

});