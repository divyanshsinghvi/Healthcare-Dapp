pragma solidity >=0.5.0 <0.6.0;

import "./HealthReportContract.sol";

contract HealthReport {
  HealthReportContract healthReportInstance;

  function initializeNewHealthReport(address _addr) public returns(address) {
    healthReportInstance = new HealthReportContract(_addr);
    return address(healthReportInstance);
  }

  function getLatestReport () public view returns(string memory, string memory, string memory) {
    return healthReportInstance.getLatestReport();
  }

  function getReportByID (uint reportID) public view returns(string memory, string memory, string memory) {
    return healthReportInstance.getReportByID(reportID);
  }

  function updateReportWithUID(uint reportID, string memory _vitals, string memory _prescriptions, string memory _symptoms) public {
    healthReportInstance.updateReportWithUID(reportID, _vitals, _prescriptions, _symptoms);
  }

  function getNumReports () public view returns(uint) {
    return healthReportInstance.getNumReports();
  }

  function createNewReport(string memory _vitals, string memory _prescriptions, string memory _symptoms) public {
    healthReportInstance.createNewReport(_vitals, _prescriptions, _symptoms);
  }
}
