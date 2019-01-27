var token = artifacts.require("./HighVibeToken.sol");
var crowdsale = artifacts.require("./HighVibeCrowdsale.sol");

module.exports = async (deployer, network, accounts) => {
  // deploy Token smart contract
  await deployer.deploy(token);

  // deploy Crowdsale smart contract
  await deployer.deploy(crowdsale, token.address);
};
