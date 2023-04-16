// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Functions{

    /*
    Functions are 
    
    public 
    private
    internal
    external

    pure
    view

    */

    function addition(uint256 number1, uint256 number2) external pure returns(uint256){

        uint number3 = number1 + number2;

        return number3;
    }

}