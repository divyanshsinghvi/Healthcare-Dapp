pragma solidity >=0.5.0 <0.6.0;

import "./HealthReport.sol";

contract Person {

  address appInterfaceAddress;

  address myAddr;
  uint myUID;
  string name;

  HealthReport myHealthReport;

  /* struct Report { */
  /*   // Mrinaal: For simplicity, keeping everything as string for now */
  /*   /\* mapping (uint => string) vitals; *\/ */
  /*   /\* mapping (uint => string) prescriptions; *\/ */
  /*   /\* uint numVitals; *\/ */
  /*   /\* uint numPrescriptions; *\/ */
  /*   string vitals; */
  /*   string prescriptions; */

  /*   string symptoms; */
  /* } */

  struct Appointment {
    string timeOfAppointment;
    uint year;
    uint month;
    uint day;
    string location;
    string appointmentId;
  }

  /* mapping (uint => uint) activeAppointmentRequests; */
  /* mapping (uint => string) currentPatientAppointments; */
  /* mapping (uint => mapping (uint => string)) listOfDoctorAppointments; */

  // Data members required for a Doctor
  bool public isDoctor = false;

  constructor (address _addr, uint _uid, bool _isDoctor) public {
    myAddr = _addr;
    myUID = _uid;
    isDoctor = _isDoctor;
    myHealthReport = new HealthReport(_addr);
    appInterfaceAddress = msg.sender;
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

  function createNewHealthReport (string memory _vitals, string memory _prescriptions, string memory _symptoms) public {
    myHealthReport.createNewReport(_vitals, _prescriptions, _symptoms);
  }

  function setName (string memory _name) public {
    name = _name;
  }
}
