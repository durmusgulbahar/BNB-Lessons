// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;  // version of Solidity 


contract Require{


    function requireKeyword()public pure returns(string memory){


        require(5>10,"10 is not lower than 5");

        return "TRUE";


    }
}