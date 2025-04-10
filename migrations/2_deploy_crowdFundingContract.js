const crowdFundingContract = artifacts.require("crowdFundingContract");

module.exports = function (deployer) {
  deployer.deploy(crowdFundingContract);
};
