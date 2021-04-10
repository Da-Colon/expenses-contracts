const EpicBadTiming = artifacts.require("EpicBadTiming");

module.exports = function (deployer) {
  // Initialize with 100,000,000 total supply
  deployer.deploy(EpicBadTiming);
};
