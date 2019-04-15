pragma solidity >=0.5.0 <0.6.0;

import "./Person.sol";

contract AppInterface {

  // Address of the admin/app-interface instance
  address admin;

  mapping (uint => Person) person;
  mapping (address => bool) isRegistered;
  mapping (address => uint) personToUID;
  mapping (uint => Person) listOfDoctors;
  /* mapping (uint => address) listOfDoctors; */

  /* mapping (uint => uint) activeAppointmentRequests; */
  /* mapping (uint => string) currentPatientAppointments; */
  /* mapping (uint => mapping (uint => string)) listOfDoctorAppointments; */

  uint numPersons = 0;
  uint numDoctors = 0;
  /* uint requestId = 0; */


  // An event which can be fired whenever a new person registers
  // This can be used to catch the address of the person's contract
  event personRegistered(address personContractAddr, uint personUID);

  constructor () public {
    admin = msg.sender;
  }

  modifier onlyAdmin {
    require(msg.sender == admin, "You are not authorized for this!!!");
    _;
  }

  function registerPerson (bool _isDoctor) public {
    numPersons++;
    person[numPersons] = new Person(msg.sender, numPersons, _isDoctor);
    personToUID[msg.sender] = numPersons;
    isRegistered[msg.sender] = true;

    emit personRegistered(address(person[numPersons]), numPersons);
  }

  function upgradeToDoctor () public {
    numDoctors++;
    listOfDoctors[numDoctors] = person[personToUID[msg.sender]];
    listOfDoctors[numDoctors].setDoctorFlag(true);
    /* listOfDoctors[numDoctors] = msg.sender; */
  }

  function isPersonRegistered () public view returns(bool, address, address) {
    /* return isRegistered[msg.sender]; */
    if (isRegistered[msg.sender])
      return (isRegistered[msg.sender], address(person[personToUID[msg.sender]]), address(person[personToUID[msg.sender]].getHealthReport()));
    else
      return (false, address(0), address(0));
  }

  /* function getLatestReport () public view returns(string memory, string memory, string memory) { */
  /*   /\* Person personContract = person[personToUID[msg.sender]]; *\/ */
  /*   return person[personToUID[msg.sender]].getLatestReport(); */
  /* } */

  // TODO: Have to implement the below mentioned function somehow
  /* function getAllReports () public view returns(string[] memory, string[] memory, string[] memory) { */
  /*   uint numReports = person[personToUID[msg.sender]].getNumReports(); */

  /*   string[] memory report = new string[](3); */
  /*   string[] memory vitals = new string[](numReports); */
  /*   string[] memory prescriptions = new string[](numReports); */
  /*   string[] memory symptoms = new string[](numReports); */

  /*   for (uint i=1; i<=numReports; ++i){ */
  /*     report = person[personToUID[msg.sender]].getReportByID(i); */
  /*     vitals[i] = report[0]; */
  /*     prescriptions[i] = report[1]; */
  /*     symptoms[i] = report[2]; */
  /*   } */

  /*   return (vitals, prescriptions, symptoms); */
  /* } */

  /* function updateReportWithUID(uint reportID, string memory vitals, string memory prescriptions, string memory symptoms) public { */
  /*   person[personToUID[msg.sender]].updateReportWithUID(reportID, vitals, prescriptions, symptoms); */
  /* } */

  function getListOfDoctors () public view returns (uint, address[] memory) {
    address[] memory doctors = new address[](numDoctors);

    for (uint i=1; i<=numDoctors; ++i){
      doctors[i] = address(listOfDoctors[i]);
      /* doctors[i] = listOfDoctors[i]; */
    }

    return (numDoctors, doctors);
  }

  function requestAppointment (uint doctorUid, uint dayAfter, string memory requestId) public { 


    require (dayAfter>=1 && dayAfter<=7, "You are only allowed to book appointments for 7 days from now");
    require (person[doctorUid].isDoctor() == true, "Appointment cannot be requested from a non-doctor"); 

    uint slotNo = person[doctorUid].requestAppointment(personToUID[msg.sender], dayAfter, requestId, true);


    require (slotNo > 0, "Could not schedule your appointment with the doctor");
    
    slotNo = person[personToUID[msg.sender]].requestAppointment(doctorUid, slotNo, requestId,false);

    require (slotNo > 0, "Could not schedule your appointment with the doctor");

    address healthReportAddress = person[personToUID[msg.sender]].grantHealthReportAccess(person[doctorUid].getMyAddress());

    bool success = person[doctorUid].addHealthReportToAccessList(healthReportAddress, personToUID[msg.sender]);
    // requestId++; 
    // activeAppointmentRequests[personToUID[msg.sender]] = requestId; 
    // return (requestId, doctorUid); 
  } 

  function completeAppointment (string memory requestId) public {


    require (person[personToUID[msg.sender]].isDoctor(), "Only a doctor can complete the appointment");
    uint patientId = person[personToUID[msg.sender]].completeAppointment(requestId, true);

    require (patientId>0, "Patient Id does not exist");
    
    uint uid = person[patientId].completeAppointment(requestId, false);
  }

  function revokeHealthReportAccess (uint doctorUid) public {

    require (person[doctorUid].isDoctor() == true, "Only doctor can revoke their access to a health report");
    
    person[personToUID[msg.sender]].revokeHealthReportAccess(person[doctorUid].getMyAddress());

    person[doctorUid].removeHealthReportFromAccessList(personToUID[msg.sender]);
  }
  
  

  /* function approveAppointment (uint patientId, string memory _timeOfAppointment, uint _year, uint _month, uint _day, string memory _location, string memory _appointmentId) public returns(string memory, uint, uint, uint, string memory, string memory) { */
  /*   // Appointment newAppointment = Appointment(_timeOfAppointment, _year, _month, _day, _location, _appointmentId); */
  /*   delete activeAppointmentRequests[patientId]; */
  /*   currentPatientAppointments[patientId] = _appointmentId; */
  /*   listOfDoctorAppointments[personToUID[msg.sender]][patientId] = _appointmentId; */
  /*   return (_timeOfAppointment, _year, _month, _day, _location, _appointmentId); */
  /* } */

  /* function rejectAppointment (uint patientId) public { */
  /*   delete activeAppointmentRequests[patientId]; */
  /* } */

  /* function completeAppointment (uint doctorId) public { */
  /*   delete currentPatientAppointments[personToUID[msg.sender]]; */
  /*   delete listOfDoctorAppointments[doctorId][personToUID[msg.sender]]; */
  /* } */

}
