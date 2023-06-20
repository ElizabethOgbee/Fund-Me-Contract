//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.8/vendor/SafeMathChainlink.sol";
contract FundMe{
    using SafeMath for uint256;
    address owner;
    mapping(address => uint256) public addressOfamountSent;
    address[] public funders;

    constructor() public{
        owner = msg.sender;
    }

    function giveMeFund() public payable{
        uint256 minimumUSD = 50 * 10 ** 18; // WE HAVE TO MAKE SURE THAT THE USER DOSENT SEND BELOW 50 DOLLARS
        require(convert(msg.value) >= minimumUSD, "YOU NEED TO SEND ATLEAST 50$");
        addressOfamountSent[msg.sender] += msg.value;

        funders.push(msg.sender); //stores the address of anyone that gives me fund in the funders array
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

    function convert(uint256 fundedAmount) public view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 inUSD = (ethPrice * fundedAmount)/1000000000000000000;
        return inUSD;
    }

    modifier admin{
        require(msg.sender == owner);
        _;
    }

    function withdraw() public  admin payable{
        msg.sender.transfer(address(this).balance);

        //RESET THE AMOUNT
        for(uint256 index = 0; index < funders.length; index++){
            address funderAddress = funders[index];
            addressOfamountSent[funderAddress] = 0;
        }
        funders = new address[](0);
    }

    
}
