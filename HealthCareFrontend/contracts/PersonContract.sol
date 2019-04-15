pragma solidity >=0.5.0 <0.6.0;


// Interface contract for HealthReport
contract HealthReportInterface {
  function initializeNewHealthReport(address _addr) public returns(address);
}

contract HealthReport {
  function getLatestReport () public view returns(string memory, string memory, string memory);

  function getReportByID (uint reportID) public view returns(string memory, string memory, string memory);

  function updateReportWithUID(uint reportID, string memory _vitals, string memory _prescriptions, string memory _symptoms) public;

  function getNumReports () public view returns(uint);

  function createNewReport(string memory _vitals, string memory _prescriptions, string memory _symptoms) public;
}


contract PersonContract {

  address appInterfaceAddress;

  address myAddr;
  uint myUID;
  string name;
  uint numAppointmentsPerDay = 5;

  HealthReport myHealthReport;

  struct Appointment {
    uint slotno;
    uint patientId;
    uint doctorId;
    string requestId;
  }

  mapping (string => Appointment) currentAppointments;
  string[] activeAppointmentIds = new string[](0);
  mapping (uint => bool) isSlotBooked;


  // Data members required for a Doctor
  bool public isDoctor = false;

  event healthReportAddress(address _addr);

  constructor (address _addr, uint _uid, bool _isDoctor, address _healthReportFactoryAddress) public {
    myAddr = _addr;
    myUID = _uid;
    isDoctor = _isDoctor;
    /* myHealthReport = new HealthReport(_addr); */
    address _healthAddr = HealthReportInterface(_healthReportFactoryAddress).initializeNewHealthReport(_addr);
    myHealthReport = HealthReport(_healthAddr);
    appInterfaceAddress = msg.sender;

    emit healthReportAddress(_healthAddr);
  }

  function getLatestReport () public view returns(string memory, string memory, string memory) {
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
    return myHealthReport.getLatestReport();
  }

  function getReportByID (uint reportID) public view returns(string memory, string memory, string memory) {
    return myHealthReport.getReportByID(reportID);
  }

  function getNumReports () public view returns(uint) {
    return myHealthReport.getNumReports();
  }

  function getName () public view returns(string memory) {
    return name;
  }

  function getUID () public view returns(uint) {
    return myUID;
  }

  function updateReportWithUID (uint reportID, string memory _vitals, string memory _prescriptions, string memory _symptoms) public {
    myHealthReport.updateReportWithUID(reportID, _vitals, _prescriptions, _symptoms);
  }

  function getHealthReport () public view returns(HealthReport) {
    return myHealthReport;
  }

  function createNewReport (string memory _vitals, string memory _prescriptions, string memory _symptoms) public {
    myHealthReport.createNewReport(_vitals, _prescriptions, _symptoms);
  }

  function setName (string memory _name) public {
    name = _name;
  }

  function setDoctorFlag (bool _isDoctor) public {
    isDoctor = _isDoctor;
  }


  function requestAppointment (uint uid, uint dayAfter, string memory requestId, bool _isDoctor) public returns(uint){

    activeAppointmentIds.push(requestId);
    if(_isDoctor) {
      currentAppointments[requestId] = Appointment(0, uid, myUID, requestId );
      uint startOfDaySlots = (dayAfter-1)*numAppointmentsPerDay + 1;
      for(uint i=startOfDaySlots; i<startOfDaySlots+numAppointmentsPerDay; i++) {
        if(!isSlotBooked[i]) {

          currentAppointments[requestId].slotno = i;
          return i;
        }
      }
      return 0;

    } else {
      /* dayAfter is actually slotno for patient */
      currentAppointments[requestId] = Appointment(dayAfter, myUID, uid, requestId);
      return 0;
    }

  }

  function completeAppointment (string memory requestId, bool _isDoctor) public returns(uint) {

    require (currentAppointments[requestId].patientId != 0x00, "The appointment corresponding to the request id does not exist");
    uint delId = activeAppointmentIds.length;
    bytes32 requestIdHash = keccak256(abi.encodePacked(requestId));
    for(uint i=0; i<activeAppointmentIds.length; i++) {
      if(keccak256(abi.encodePacked(activeAppointmentIds[i])) == requestIdHash) {
        delId = i;
        break;
      }
    }

    require (delId>=0 && delId < activeAppointmentIds.length, "Request id was not found in the list of active appointment ids");

    uint personId = 0;
    activeAppointmentIds[delId] = activeAppointmentIds[activeAppointmentIds.length -1];
    delete activeAppointmentIds[activeAppointmentIds.length - 1];

    if(_isDoctor) {
      isSlotBooked[currentAppointments[requestId].slotno] = false;
      personId = currentAppointments[requestId].patientId;
    }

    delete currentAppointments[requestId];
    return personId;

  }

  function getAppointmentsData () public view returns (byte[36][] memory, uint[] memory, uint[] memory, uint[] memory) {
    uint[] memory slotNo = new uint[](activeAppointmentIds.length);
    uint[] memory patientIdArray = new uint[](activeAppointmentIds.length);
    uint[] memory doctorIdArray = new uint[](activeAppointmentIds.length);
    byte[36][] memory requestIdArray = new byte[36][](activeAppointmentIds.length);
    bytes memory requestIdByte;
    for(uint i=0; i<activeAppointmentIds.length; i++) {
      requestIdByte = bytes(activeAppointmentIds[i]);
      for(uint j=0; j<requestIdByte.length; ++j)
        requestIdArray[i][j] = requestIdByte[j];

      slotNo[i] = currentAppointments[activeAppointmentIds[i]].slotno;
      patientIdArray[i] = currentAppointments[activeAppointmentIds[i]].patientId;
      doctorIdArray[i] = currentAppointments[activeAppointmentIds[i]].doctorId;
    }
    return (requestIdArray, slotNo, patientIdArray, doctorIdArray);
  }



  event printArr(string val);
  function printArray() public {
    for(uint i=0; i<activeAppointmentIds.length; i++)
      emit printArr(activeAppointmentIds[i]);
  }

}
