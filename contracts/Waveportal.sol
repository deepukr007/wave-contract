// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract  Waveportal 
{
    uint256 totalWaves;
    uint256 private seed;

    mapping(address => uint256) public lastWavedAt;
    
    
    constructor () payable
    {
    console.log("Hello , World (Decentralised) ");
    seed = (block.timestamp + block.difficulty) % 100;
   
    }

    event NewWave(address indexed from, uint256 timestamp, string message);

     struct Wave {
        address waver; // The address of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
    }

    Wave[] waves;


    mapping(address=>uint) AdressToWaves;


    function wave(string memory _message) public {
        totalWaves= totalWaves+1;  // I hate shorthands xD
        AdressToWaves[msg.sender] +=1;
        console.log("%s has waved %d times" , msg.sender , AdressToWaves[msg.sender]);
        waves.push(Wave(msg.sender, _message, block.timestamp));

        require(
            lastWavedAt[msg.sender] + 15 minutes < block.timestamp,
            "Wait 15m"
        );
        
        lastWavedAt[msg.sender] = block.timestamp;


         seed = (block.difficulty + block.timestamp + seed) % 100;

        /*
         * Give a 50% chance that the user wins the prize.
         */
        if (seed <= 50) {
            console.log("%s won!", msg.sender);
            uint256 prizeAmount = 0.0001 ether;
            require(prizeAmount <= address(this).balance,"Trying to withdraw more money than the contract has.");
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
             require(success, "Failed to withdraw money from contract.");
        }



        emit NewWave(msg.sender, block.timestamp, _message);

    }

    function getTotalWaves() public view returns(uint256)
    {
        console.log("I got %d total waves!", totalWaves);
        return totalWaves;
    }

     function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getWavesBySender() public view  returns(uint256){
     console.log("Hey %s , Thanks for the %d waves in total", msg.sender , AdressToWaves[msg.sender] );
     return  AdressToWaves[msg.sender];
    }

}
