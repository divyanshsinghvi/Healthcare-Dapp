var AppInterface = artifacts.require("./AppInterface.sol");
var HealthReportInterface = artifacts.require("./HealthReportInterface.sol");
var PersonInterface = artifacts.require("./PersonInterface.sol");

module.exports = function(deployer) {
     deployer.deploy(HealthReportInterface).then(function() {   
       return deployer.deploy(PersonInterface).then(function() {
             return deployer.deploy(AppInterface, PersonInterface.address);
         });
     });
    // deployer.deploy(HealthContractInterface);
};
