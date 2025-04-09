// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract crowdFunding{
    string public campaign_name;
    string public campaign_description;
    uint256 public goal_amount;
    uint256 public campaign_deadline;
    address public campaign_owner;
    bool public campaign_paused;

    enum campaignState {Active, Successful, Failed} 
    campaignState public state;

    struct tier{
        string tier_name;
        uint256 amount;
        uint256 backers;
    }

    struct backer{
        uint256 total_contribution;
        mapping(uint256=>bool) fundedTiers;
    }

    tier[] public tiers;
    mapping(address=>backer) public backers;

    modifier onlyOwner(){
        require(msg.sender==campaign_owner, "Not campaign owner");
        _; 
    }

    modifier campaignOpen(){
        require(state==campaignState.Active, "Campaign is not active");
        _;
    }

    modifier notPaused(){
        require(!campaign_paused, "Campaign is paused");
        _;
    }

    constructor(address owner, string memory name, string memory description, uint256 goal, uint256 durationInDays){
        campaign_name=name;
        campaign_description=description;
        goal_amount=goal;
        campaign_deadline=block.timestamp+(durationInDays*1 days);
        campaign_owner=owner;
        state=campaignState.Active;
    }

    function fund(uint256 tierIndex) public payable campaignOpen notPaused {
        require(tierIndex<tiers.length, "Invalid Tier");
        require(msg.value==tiers[tierIndex].amount, "Invalid amount backed");

        tiers[tierIndex].backers++;
        backers[msg.sender].total_contribution+=msg.value;
        backers[msg.sender].fundedTiers[tierIndex]=true;
 
        checkAndUpdateCampaignState();
    }

    function withdraw() public onlyOwner {
        checkAndUpdateCampaignState();
        require(state==campaignState.Successful, "Campaign not successful");

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

    function checkAndUpdateCampaignState() internal{
        if(state==campaignState.Active){
            if(block.timestamp>=campaign_deadline){
                state=address(this).balance>=goal_amount? campaignState.Successful: campaignState.Failed;
            }else{
                state=address(this).balance>=goal_amount? campaignState.Successful: campaignState.Active;
            }
        }
    }

    function refund() public {
        checkAndUpdateCampaignState();
        require(state==campaignState.Failed, "Campaign is not failed");

        uint256 amount=backers[msg.sender].total_contribution;
        require(amount>0, "No contribution to refund");

        backers[msg.sender].total_contribution=0;
        payable(msg.sender).transfer(amount);
    }

    function hasFundedTier(address backer_address, uint256 tierIndex) public view returns (bool){
        return backers[backer_address].fundedTiers[tierIndex];
    }

    function getTiers() public view returns (tier[] memory){
        return tiers;
    }

    function tooglePause() public onlyOwner {
        campaign_paused=!campaign_paused;
    }

    function getCampaignStatus() public view returns (campaignState) {
        if(state==campaignState.Active && block.timestamp>campaign_deadline){
            return address(this).balance>=goal_amount?campaignState.Successful:campaignState.Failed;
        }
        return state;
    }

    function extendDeadline(uint256 daysToAdd) public onlyOwner {
        campaign_deadline+=daysToAdd*1 days;
    }
}