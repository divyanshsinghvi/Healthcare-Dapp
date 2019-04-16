pragma solidity >=0.5.0 <0.6.0;

import "./HealthReportContract.sol";

contract HealthReportInterface {
  HealthReportContract healthReportInstance;

  function initializeNewHealthReport(address _addr) public returns(address) {
    healthReportInstance = new HealthReportContract(_addr, msg.sender);
    return address(healthReportInstance);
  }

}
