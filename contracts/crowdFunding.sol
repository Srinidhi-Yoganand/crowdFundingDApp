// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract crowdFunding{
    string public campaign_name;
    string public campaign_description;
    uint256 public goal_amount;
    uint256 public campaign_deadline;
    address public campaign_owner;

    constructor(string memory name, string memory description, uint256 goal, uint256 durationInDays){
        campaign_name=name;
        campaign_description=description;
        goal_amount=goal;
        campaign_deadline=block.timestamp+(durationInDays*1 days);
        campaign_owner=msg.sender;
    }

    function fund() public payable {
        require(msg.value>0, "Must fund more than 0");
        require(block.timestamp<campaign_deadline, "Sorry campagin has ended");
    }

    function withdraw() public {
        require(msg.sender==campaign_owner, "Not campaign owner");
        require(address(this).balance>=goal_amount, "Goal not completed yet");

        uint256 balance=address(this).balance;
        require(balance>0, "Nothing to withdraw");

        payable(campaign_owner).transfer(balance);
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}