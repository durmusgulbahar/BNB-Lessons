const { expect } = require("chai");
const { ethers } = require("hardhat");


describe("Simple Contract", function () {
    let simpleContract;
    let owner;
    let addr2;

    beforeEach(async function () {
        const Simple = await ethers.getContractFactory("Simple");
        const simple = await Simple.deploy();
        await simple.deployed();
        simpleContract = simple;
        [owner,addr2] = await ethers.getSigners();
    });

    it("Owner bizim adresimize eşit olmalı", async function () {
        console.log(owner.address);
        expect(await simpleContract.owner()).to.equal(owner.address);
        
    })

    it("increment() fonksiyonunu ownerdan başkası çağıramaz", async function () {
        await expect(simpleContract.connect(addr2).increment()).to.be.revertedWith("Not allowed");
    })
    

    it("x değişkeni 0 dan küçük olamaz", async function () {
        await expect(simpleContract.decrement()).to.be.revertedWith("x can not be negative");
    })   

    it("increment() fonksiyonunu sadece owner çağırabilir", async function () {
        expect(await simpleContract.increment());
    })

    it("increment() fonksiyonu çalıştırıldığında x değişkeni 1 artmalı", async function () {    
        await simpleContract.increment();
        expect(await simpleContract.x()).to.equal(1);
    })



} )