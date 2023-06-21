//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/vendor/SafeMathChainlink.sol";

library PriceConverter{
        function getVersion() external view returns(uint256) {
        AggregatorV3Interface data = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return data.version();
    }

    function getPrice() external view returns(uint256){
        AggregatorV3Interface rate = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 answer,,,) = rate.latestRoundData();
        return uint256(answer);
    }

    function convert(uint256 amountFunded_) external view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 nUSD = (ethPrice * amountFunded_)/1000000000000000000;
        return inUSD;
    }

}
