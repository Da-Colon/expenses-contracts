const Treasury = artifacts.require("TreasuryContract");

module.exports = function (deployer) {
  deployer.deploy(Treasury);
};