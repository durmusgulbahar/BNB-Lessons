//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Simple{
    int public x;
    address public immutable owner;
    constructor(){
        owner = msg.sender;
        x = 0;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Not allowed");
        _;
    }

    function increment() public onlyOwner{
        x += 1;
    }

    function decrement() public {
        require(x > 0, "x can not be negative");
        x -= 1;
    }
}