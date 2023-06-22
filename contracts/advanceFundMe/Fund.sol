//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./fundMeUsingLibrary/PriceConverter.sol";
error nowOwner();

contract GiveMeCash {
    using PriceConverter for uint256;

    address immutable owner;
    uint256 constant MINIMUM_USD = 50 * 10 ** 18;

    mapping(address => uint256) public addressWithCash;
    address[] public funders; // STORING ALL THE ADDRESS OF THOSE GIVING ME MONEY IN AN ARRAY

    constructor() public {
        owner = msg.sender; // sender of the message is us
        // one that deploys the smart contract
    }

    function fundMe() public payable {
        // require(convert(msg.value) >= minimumUSD, "YOU NEED TO SEND ATLEAST 50$" );//WE NEED TO CREATE A FUNCTION FOR CONVERT
        require(
            msg.value.convert() >= minimumUSD,
            "YOU NEED TO SEND ATLEAST 50$"
        ); //WE NEED TO CREATE A FUNCTION FOR CONVERT
        addressWithCash[msg.sender] += msg.value;

        funders[].push[msg.sender];
    }

    modifier admin() {
        require(msg.sender == owner, "ONLY OWNERS CAN WITHDRAW ");
        if (msg.sender != owner) {
            revert nowOwner();
        }
        _;
    }

    function withdraw() public admin {
        //WE WANT TO WITHDRAW ALL THE CASH AND RESET THE AMOUNT TO ZERO IN THE ARRAY
        for (index = 0; index < funders.length; index++) {
            address funderAddress = funders[index];
            addressFundedAmount[funderAddress] = 0;
        }
        funders = new address[](0); // RESETTING ARRAY

        // transfer
        // payable(msg.sender).transfer(address(this).balance); // this refers to whole contract

        // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed!");

        //i use call intradof transfer or send to transfer cash from this contract to another
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "CALL FAILED");
    }

    receive() external payable {
        fundMe();
    }

    fallback() external payable {
        fundMe();
    }
}
