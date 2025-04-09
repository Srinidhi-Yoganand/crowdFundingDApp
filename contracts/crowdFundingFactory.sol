// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import {crowdFunding} from "./crowdFunding.sol";

contract crowdFundingContract{
    address public owner;
    bool public paused;

    struct campaign{
        address campaign_address;
        address owner;
        string name;
        uint256 creationTime;
    }

    campaign[] public campaigns;
    mapping(address=>campaign[]) public user_campaigns;

    modifier onlyOwner(){
        require(msg.sender==owner, "Not owner");
        _;
    }

    modifier notPaused(){
        require(!paused, "Factory is paused");
        _;
    }

    constructor(){
        owner=msg.sender;
    }

    function createCampaign(string memory name, string memory description, uint256 goal, uint256 durationInDays) external notPaused{
        crowdFunding newCampaign=new crowdFunding(msg.sender, name, description, goal, durationInDays);
        address campaignAddress=address(newCampaign);

        campaign memory Campaign=campaign({
            campaign_address:campaignAddress,
            owner:msg.sender,
            name:name,
            creationTime:block.timestamp
        });

        campaigns.push(Campaign);
        user_campaigns[msg.sender].push(Campaign);
    }

    function getUserCampaigns(address user) external view returns (campaign[] memory) {
        return user_campaigns[user];
    }

    function getAllCampaigns() external view returns (campaign[] memory) {
        return campaigns;
    }

    function togglePause() external onlyOwner {
        paused=!paused;
    }
}