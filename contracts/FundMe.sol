
//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe{
    mapping(address => uint256) public amountSent;

    function giveMeFund() public payable{
        amountSent[msg.sender] += msg.value;
    }

function getVersion() public view returns(uint256){
        AggregatorV3Interface rate = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        return rate.version();
    }

    function getPrice() public view returns(uint256){
        AggregatorV3Interface rate = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        (,int256 answer,,,) = rate.latestRoundedData();
        return uint256(answer);
           }
    
}
