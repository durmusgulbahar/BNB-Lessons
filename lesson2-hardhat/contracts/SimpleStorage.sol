// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract SimpleStorage{
    uint storedData; // default 0

    function set(uint _data) public{
        storedData = _data;
    }

    function get() public view returns(uint){
        return storedData;
    }
}