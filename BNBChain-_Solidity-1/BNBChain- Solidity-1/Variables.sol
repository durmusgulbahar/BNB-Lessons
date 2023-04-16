

// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Variables{

    /*
    
    bool -> boolean ; True or False. Default False
    int256 -> integer ; Numbers between -2 ** 255 to 2 ** 255 - 1 
    uint256 -> unsigned integer ; Numbers between 0 to 2**255-1
    address ; Address of a wallet or a contract
    string ; char array, text
    array ; List of variables
    mapping ; List of key-value pairs 

    State variables ; Contract's variables and stored contract memory. permanent. 
    Local variables ; Function variables, temporary.
    Global variables ; Variables of blockchain. msg.sender

    */

    bool public trueOrFalse;

    int256 public ten;

    uint256 public twenty = 20;

    uint public example = 1000;

    string public name; // ""


    address public contractAddress = address(this); // 0x7EF2e0048f5bAeDe046f6BF797943daF4ED8CB47

    // Lists

    uint[] public numbers = [1,2,3,4,5];

    string[] public letters = ["a","b","c","d"];
    
    // mapping

    mapping(string => uint) public nameAndNumber;


    function addElementToTheMapping() public {
        
        nameAndNumber["Eyyub"] = 24;

        nameAndNumber["Baby"] = 2;

    }

    /*
    Ten => 10 
    Five => 5
    Zero => 0
    */

}