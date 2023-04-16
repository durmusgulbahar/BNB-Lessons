//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;


contract Tweether {
  
  struct Tweet{
    uint tweetId; // 0
    address owner; // 0
    uint likes; // 0
    mapping(address => bool) likedBy; // K V ->  address bool    0x123 -> true
    string text; // ""
    uint createdAt; // 0
    string image; // ""
  }

  Tweet[] public tweets;
  uint public lastTweetId;

  constructor(){
    lastTweetId = 0;
  }

  // @@@ EVENTS @@@
  event CreateTweet(uint tweetId, address sender, string text, string image);
  event LikeTweet(uint tweetId, address sender);
  event DeleteTweet(uint tweetId, address sender);
  event EditTweet(uint tweetId, address sender);
  
  // @@@ MODIFIERS @@@
  modifier exists(uint tweetId){
    
    require(tweetId < lastTweetId, "Tweet doesn't exist");
    _;
  }

  modifier onlyOwner(uint tweetId){
    require(tweets[tweetId].owner == msg.sender, "Not allowed");
    _;
  }
  // @@@ FUNCTIONS @@@

  function createTweet(string memory text, string memory image) public returns(uint){
     Tweet storage newTweet = tweets.push();
     
     newTweet.tweetId = lastTweetId;
     newTweet.text = text;
     newTweet.createdAt = block.timestamp;
     newTweet.image = image;
     newTweet.owner = msg.sender;
     newTweet.likes = 0;

     emit CreateTweet({tweetId: lastTweetId, sender: msg.sender, text: text, image: image});
     lastTweetId += 1;
     return lastTweetId-1;

  }

  function likeTweet(uint tweetId) public exists(tweetId) {

    if(tweets[tweetId].likedBy[msg.sender] == true){
      tweets[tweetId].likes -=1;
    }    
    else{
      tweets[tweetId].likes +=1;
    }
    tweets[tweetId].likedBy[msg.sender] = !tweets[tweetId].likedBy[msg.sender];
    emit LikeTweet(tweetId, msg.sender);
  } 

  function deleteTweet(uint tweetId) public exists(tweetId) onlyOwner(tweetId) {
    delete tweets[tweetId];
    emit DeleteTweet(tweetId, msg.sender);
  }

  function editTweet(uint tweetId, string memory text) public exists(tweetId) onlyOwner(tweetId) {
    Tweet storage tweet = tweets[tweetId];
    tweet.text = text;
    emit EditTweet(tweetId,msg.sender);
  }


  function getTweet(uint tweetId) public view exists(tweetId) returns(
      uint, address, uint, string memory, uint, string memory
  ){
    Tweet storage tweet = tweets[tweetId];
    return(
        tweet.tweetId,
        tweet.owner,
        tweet.createdAt,
        tweet.image,
        tweet.likes,
        tweet.text
    );
  }

  function getTotalTweet() public view returns(uint){
    return tweets.length;
  }
  }


