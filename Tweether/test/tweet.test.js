const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Tweether",function()  {
  let tweether;
  let owner;
  let addr2;

  beforeEach(async () => {
    const tweet = await ethers.getContractFactory("Tweether");
    const tweetC = await tweet.deploy();  
    await tweetC.deployed();
    tweether = tweetC;
    [owner, addr2] = await ethers.getSigners();

  });

  describe("createTweet", () => {
    it("should create a new tweet", async () => {
        await tweether.createTweet("İlk tweet","");
        expect(await tweether.lastTweetId()).to.equal(1);
    });
  });

  describe("likeTweet", () => {
    it("should like a tweet", async () => {
        await tweether.createTweet("İlk tweet","");
        await tweether.likeTweet(0);
        const t = await tweether.getTweet(0);
        console.log(t)
        expect(await t[4]).to.equal(1);


    });

    it("should unlike a tweet", async () => {
        await tweether.createTweet("İlk tweet","");
        await tweether.likeTweet(0);
        await tweether.likeTweet(0);
        const t = await tweether.getTweet(0);
 
        expect(await t[4]).to.equal(0);
    });
  });

  describe("deleteTweet", () => {
    it("should delete a tweet", async () => {
        await tweether.createTweet("İlk tweet","");
        await tweether.deleteTweet(0);
        const t = await tweether.getTweet(0);
        expect(await t[5]).to.equal("");
    });

    it("should not delete someone else's tweet", async () => {
        await tweether.createTweet("İlk tweet","");
        await expect(tweether.connect(addr2).deleteTweet(0)).to.be.revertedWith("Not allowed");
    });
  });

  describe("editTweet", () => {
    it("should edit a tweet", async () => {
        await tweether.createTweet("İlk tweet","");
        await tweether.editTweet(0,"İlk tweet düzenlendi");
        const t = await tweether.getTweet(0);
        expect(await t[5]).to.equal("İlk tweet düzenlendi");
    });

    it("should not edit someone else's tweet", async () => {
        await tweether.createTweet("İlk tweet","");
        await expect(tweether.connect(addr2).editTweet(0,"İlk tweet düzenlendi")).to.be.revertedWith("Not allowed");
    });
  });   });