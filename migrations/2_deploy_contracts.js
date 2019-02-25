var token = artifacts.require("./HighVibeToken.sol");

module.exports = async (deployer, network, accounts) => {
  // deploy Token smart contract
  await deployer.deploy(token);
};
