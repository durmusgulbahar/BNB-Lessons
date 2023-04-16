// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Conditions{


    /*


    */


    function ifElse() public pure returns(string memory){

        if( 10 < 5 ){ // if condition is true
            return "Lower";
        }

        else{ // condition is false
            return "Not Lower";
        }


    }

}