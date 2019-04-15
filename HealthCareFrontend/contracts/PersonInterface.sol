pragma solidity >=0.5.0 <0.6.0;

import "./PersonContract.sol";


contract PersonInterface {

  mapping (uint => PersonContract) personInstance;
  address healthReportFactoryAddress;


  function initializeHealthReportFactoryAddress (address _healthReportFactoryAddress) public {
    healthReportFactoryAddress = _healthReportFactoryAddress;
  }

  function initializeNewPerson(address _addr, uint _uid, bool _isDoctor) public returns(address) {
    require(healthReportFactoryAddress != address(0x00), "Address for Health Report Factory is not initialized");
    personInstance[_uid] = new PersonContract(_addr, _uid, _isDoctor, healthReportFactoryAddress);
    return address(personInstance[_uid]);
  }
}
