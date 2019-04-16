var AppInterface = artifacts.require("./AppInterface.sol");
var HealthReportInterface = artifacts.require("./HealthReportInterface.sol");
var PersonInterface = artifacts.require("./PersonInterface.sol");

module.exports = function(deployer) {
     deployer.deploy(HealthReportInterface).then(function() {   
     });
         deployer.deploy(PersonInterface).then(function(instance) {
             instance.initializeHealthReportFactoryAddress(HealthReportInterface.address);
             return deployer.deploy(AppInterface, PersonInterface.address);
         });
    // deployer.deploy(HealthContractInterface);
};
