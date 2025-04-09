// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract crowdFunding{
    string public campaign_name;
    string public campaign_description;
    uint256 public goal_amount;
    uint256 public campaign_deadline;
    address public campaign_owner;

    struct tier{
        string tier_name;
        uint256 amount;
        uint256 backers;
    }

    tier[] public tiers;

    modifier onlyOwner(){
        require(msg.sender==campaign_owner, "Not campaign owner");
        _; 
    }

    constructor(string memory name, string memory description, uint256 goal, uint256 durationInDays){
        campaign_name=name;
        campaign_description=description;
        goal_amount=goal;
        campaign_deadline=block.timestamp+(durationInDays*1 days);
        campaign_owner=msg.sender;
    }

    function fund(uint256 tierIndex) public payable {
        require(block.timestamp<campaign_deadline, "Sorry campagin has ended");
        require(tierIndex<tiers.length, "Invalid Tier");
        require(msg.value==tiers[tierIndex].amount, "Invalid amount backed");

        tiers[tierIndex].backers++;
    }

    function withdraw() public onlyOwner {
        require(address(this).balance>=goal_amount, "Goal not completed yet");

        uint256 balance=address(this).balance;
        require(balance>0, "Nothing to withdraw");

        payable(campaign_owner).transfer(balance);
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function addTier(string memory name, uint256 amount) public onlyOwner {
        require(amount>0, "Amount must be greater than 0");
        tiers.push(tier(name, amount, 0));
    }

    function removeTier(uint256 index) public onlyOwner {
        require(index<tiers.length, "Tier does not exist");
        tiers[index]=tiers[tiers.length-1];
        tiers.pop();
    }
}