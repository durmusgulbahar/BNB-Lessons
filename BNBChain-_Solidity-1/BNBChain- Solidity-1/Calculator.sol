// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Calculator{

    uint public additionResult;
    uint public subtractionResult;
    uint public multiplicationResult;
    uint public divisionResult;

    function addition(uint num1, uint num2) public {

        require(num1>10,"Num1 must be greater than 10");
        
        additionResult = num1 + num2;

    }


    function subtraction(uint num1, uint num2) public {

        subtractionResult = num1 - num2 ;

        
    }

    function multiplication(uint num1, uint num2) public pure returns(uint){

        uint result = num1 * num2;

        return result;
    }

    function division(uint num1, uint num2) public pure returns(uint){
        
        uint result = num1 / num2;

        return result;
    }
}