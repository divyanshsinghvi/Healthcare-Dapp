pragma solidity >=0.5.0 <0.6.0;

contract HealthReportContract {

  address owner;
  address ownerContractAddress;

  mapping (uint => string) vitals;
  mapping (uint => string) prescriptions;
  mapping (uint => string) symptoms;
  uint numReports;

  mapping (address => bool) isAuthorized;

  constructor (address _owner) public {
    owner = _owner;
    ownerContractAddress = msg.sender;
    numReports = 0;
  }

  // TODO: Have to check which address will be coming in place of msg.sender
  /* modifier checkAccess { */
  /*   require(msg.sender==owner || isAuthorized[msg.sender], "You are not authorized to access the Health Reports of this person"); */
  /*   _; */
  /* } */

  function getLatestReport () public view returns(string memory, string memory, string memory) {
    require(numReports > 0, "There are no health records for the person yet");

    return (vitals[numReports], prescriptions[numReports], symptoms[numReports]);
  }

  function getReportByID (uint reportID) public view returns(string memory, string memory, string memory) {
    require(reportID>=1 && reportID<=numReports, "The report with the given Report ID does not exist.");

    return (vitals[reportID], prescriptions[reportID], symptoms[reportID]);
  }

  function updateReportWithUID(uint reportID, string memory _vitals, string memory _prescriptions, string memory _symptoms) public {
    require(reportID>=1 && reportID<=numReports, "The report with the given Report ID does not exist.");

    vitals[reportID] = _vitals;
    prescriptions[reportID] = _prescriptions;
    symptoms[reportID] = _symptoms;
  }

  function getNumReports () public view returns(uint) {
    return numReports;
  }

  function createNewReport(string memory _vitals, string memory _prescriptions, string memory _symptoms) public {
    numReports++;
    vitals[numReports] = _vitals;
    prescriptions[numReports] = _prescriptions;
    symptoms[numReports] = _symptoms;
  }

  function grantHealthReportAccess (address doctorAddress) public returns(bool) {
    
    // require (msg.sender == ownerContractAddress, "Only owner of health report can grant access");
    isAuthorized[doctorAddress] = true;
    return true;
  }

  function revokeHealthReportAccess (address doctorAddress) public {
    // require (msg.sender == ownerContractAddress, "Only owner of health report can revoke access");
    delete isAuthorized[doctorAddress];
  }
}
