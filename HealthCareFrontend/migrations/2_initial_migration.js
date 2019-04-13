var AppInterface = artifacts.require("./AppInterface.sol");

module.exports = function(deployer) {
  deployer.deploy(AppInterface);
};
