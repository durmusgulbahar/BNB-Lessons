// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Tweether{
    struct Tweet{
        uint tweetId;
        address owner;
        uint likes;
        mapping(address => bool) likedBy;
        string text;
        uint createdAt;
    }

    uint public lastTweetId;
    Tweet[] private tweetsList;

    mapping(address=>Tweet[]) private tweets;

    constructor(){
        lastTweetId = 0;
    }

    event CreateTweet(uint tweetId, address sender, string text);
    event LikeTweet(uint tweetId, address sender);
    event DeleteTweet(uint tweetId, address sender);

    modifier exists(uint tweetId){
        require(tweetId < lastTweetId, "The specified tweet doesn't exist");
        _;
    }

    modifier onlyOwner(uint tweetId){
        require(tweets[tweetId].owner == msg.sender, "Not allowed");
        _;
    }

    function createTweet(string memory text) public returns(uint){

        Tweet tweet = Tweet(
                {tweetId: lastTweetId, owner: msg.sender, text: text, createdAt: block.timestamp}
            );
        tweet.tweetId = lastTweetId;
        tweet.owner = msg.sender;
        tweet.text = text;
        tweet.createdAt = block.timestamp;



        emit CreateTweet({ tweetId: lastTweetId, sender: msg.sender, text: text});
        lastTweetId += 1;
        return lastTweetId - 1;
    }



    function getTweet(uint tweetId) public view exists(tweetId)
        returns(uint, address, uint[] memory, uint, bool, string memory, uint, bool, uint) {
        Tweet storage tweet = tweets[tweetId];
        return (
            tweet.tweetId,
            tweet.owner,
            tweet.likes,
            tweet.likedBy[msg.sender],
            tweet.text,
            tweet.createdAt,

        );
    }
    function likeTweet(uint tweetId) public exists(tweetId) returns(bool) {
        if(tweets[tweetId].likedBy[msg.sender] == true){
            tweets[tweetId].likes -= 1;
        }else{
            tweets[tweetId].likes += 1;
        }
        tweets[tweetId].likedBy[msg.sender] = !tweets[tweetId].likedBy[msg.sender];
        emit LikeTweet({ tweetId: lastTweetId, sender: msg.sender });
        return tweets[tweetId].likedBy[msg.sender];
    }

    function deleteTweet(uint tweetId) public exists(tweetId) onlyOwner(tweetId) returns(bool) {
        delete tweets[tweetId];
        emit DeleteTweet({ tweetId: lastTweetId, sender: msg.sender });
        return true;
    }

}