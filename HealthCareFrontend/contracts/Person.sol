pragma solidity >=0.5.0 <0.6.0;

import "./PersonContract.sol";


contract Person {

  mapping (uint => PersonContract) personInstance;
  address healthReportFactoryAddress;

  /* constructor (address _healthReportFactoryAddress) public { */
  /*   healthReportFactoryAddress = _healthReportFactoryAddress; */
  /* } */

  function initializeHealthReportFactoryAddress (address _healthReportFactoryAddress) public {
    healthReportFactoryAddress = _healthReportFactoryAddress;
  }

  function initializeNewPerson(address _addr, uint _uid, bool _isDoctor) public returns(address) {
    require(healthReportFactoryAddress != address(0x00), "Address for Health Report Factory is not initialized");

    personInstance[_uid] = new PersonContract(_addr, _uid, _isDoctor, healthReportFactoryAddress);
    return address(personInstance[_uid]);
  }

  function initializeInstance (uint _uid, address _addr) public {
    personInstance[_uid] = PersonContract(_addr);
  }

  function getLatestReport (uint _uid) public view returns(string memory, string memory, string memory) {
    /* Report memory latestReport = myReports[numReports]; */
    /* uint i; */
    /* vitals = ""; */
    /* prescriptions = ""; */

    /* for(i=1; i<=myReports[numReports].numVitals; ++i){ */
    /*   /\* vitals += myReports[numReports].vitals[i] + "; "; *\/ */
    /*   // TODO: Have to write concatenate function for string; */
    /* } */

    /* for(i=1; i<=myReports[numReports].numPrescriptions; ++i){ */
    /*   prescriptions += myReports[numReports].prescriptions[i]; */
    /* } */

    /* return (vitals, prescriptions, myReports[numReports].symptoms); */
    /* return (myReports[numReports].vitals, myReports[numReports].prescriptions, myReports[numReports].symptoms); */
    return personInstance[_uid].getLatestReport();
  }

  function getReportByID (uint _uid, uint reportID) public view returns(string memory, string memory, string memory) {
    return personInstance[_uid].getReportByID(reportID);
  }

  function getNumReports (uint _uid) public view returns(uint) {
    return personInstance[_uid].getNumReports();
  }

  function getName (uint _uid) public view returns(string memory) {
    return personInstance[_uid].getName();
  }

  function getUID (uint _uid) public view returns(uint) {
    return personInstance[_uid].getUID();
  }

  function updateReportWithUID (uint _uid, uint reportID, string memory _vitals, string memory _prescriptions, string memory _symptoms) public {
    personInstance[_uid].updateReportWithUID(reportID, _vitals, _prescriptions, _symptoms);
  }

  function getHealthReport (uint _uid) public view returns(address) {
    return address(personInstance[_uid].getHealthReport());
  }

  event checkInstance(address);
  function isDoctor(uint _uid) public returns(bool) {
    emit checkInstance(address(personInstance[_uid]));
    return personInstance[_uid].isDoctor();
  }

  function createNewHealthReport (uint _uid, string memory _vitals, string memory _prescriptions, string memory _symptoms) public {
    personInstance[_uid].createNewReport(_vitals, _prescriptions, _symptoms);
  }

  function setName (uint _uid, string memory _name) public {
    personInstance[_uid].setName(_name);
  }

  function setDoctorFlag (uint _uid, bool _isDoctor) public {
    personInstance[_uid].setDoctorFlag(_isDoctor);
  }


  function requestAppointment (uint _uid, uint uid, uint dayAfter, string memory requestId, bool _isDoctor) public returns(uint){
    return personInstance[_uid].requestAppointment(uid, dayAfter, requestId, _isDoctor);
  }

  function completeAppointment (uint _uid, string memory requestId, bool _isDoctor) public returns(uint) {
    return personInstance[_uid].completeAppointment(requestId, _isDoctor);
  }

  /* function getAppointmentsData () public view returns (byte[36][] memory, uint[] memory, uint[] memory, uint[] memory) { */
  /*   return personInstance.getAppointmentsData(); */
  /* } */

  function printArray(uint _uid) public {
    personInstance[_uid].printArray();
  }

}
