var token = artifacts.require("./HighVibeToken.sol");
var crowdsale = artifacts.require("./HighVibeCrowdsale.sol");

module.exports = async (deployer, network, accounts) => {
  // deploy Token smart contract and log the gas used
  await deployer.deploy(token);

  // deploy Crowdsale smart contract and log the gas used
  await deployer.deploy(crowdsale, token.address);
};
