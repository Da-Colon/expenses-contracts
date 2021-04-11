const Expenses = artifacts.require("Expenses");

module.exports = function (deployer) {
  deployer.deploy(Expenses);
};