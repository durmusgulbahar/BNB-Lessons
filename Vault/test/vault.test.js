const { expect } = require("chai");
const { ethers } = require("hardhat");



describe("Vault", function () {

    let vault;
    let owner; // 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
    let addr2; // 0x70997970C51812dc3A010C7d01b50e0d17dc79C8

    beforeEach(async function(){
        const v = await ethers.getContractFactory("Vault");
        vault = await v.deploy();
        await vault.deployed();

        [owner, addr2] = await ethers.getSigners();
    })
    // 1 ether = 1000000000000000000 wei
    it("Kullanıcı stake yaptığında kullanıcın balance artmalı",async function(){

        const amount = ethers.utils.parseEther("1.0");

        await vault.stake(1,{value: amount});

        expect(await vault.getStakeAmount(owner.address)).to.be.at.least(0);

    })

    // it("Kullanıcı stake yaparken %5 komisyon kesmeli", async function(){

    // })

    it("Kullanıcı zamanından önce token çekememeli" , async function(){
        const amount = ethers.utils.parseEther("1.0");

        await vault.stake(1000,{value: amount});

        await expect(vault.withdraw()).to.be.revertedWith("You can not withdraw before time");
    })

    it("Stake yapmayan bir cüzdan token çekmeye çalışırsa hata vermeli", async function(){
        const amount = ethers.utils.parseEther("1.0");

        await vault.stake(1000,{value: amount});

        await expect(vault.connect(addr2).withdraw()).to.be.revertedWith("You are not a staker");
    })

    it("Kullanıcı zaman dolduğunda tokenlerini çekebilmeli", async function(){
        const amount = ethers.utils.parseEther("1.0");

        await vault.stake(0,{value: amount});
        // wait for 1 second  with sleep function
        const result = await vault.withdraw();
        console.log(result)
        expect(result.wait).to.equal(1);

    })

    // it("Kullanıcı zamanından önce token çekmeyi kabul ederse %10 komisyon kesmeli", async function(){

    // })

    it("calculateReward() fonksyionu doğru sonuç vermeli, 10 BNB , 10 saat için 0.1 BNB ödül vermeli, kullanıcı 9.6 BNB çekmeli ", async function(){
        const result = await vault.calculateReward(ethers.utils.parseEther("10.0"), 10);
        // 0.1

        expect(result).to.equal(ethers.utils.parseEther("0.1"));
    })


});