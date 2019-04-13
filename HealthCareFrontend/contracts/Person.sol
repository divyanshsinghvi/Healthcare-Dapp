pragma solidity >=0.5.0 <0.6.0;

contract Person {

  address myAddr;
  uint myUID;
  string name;

  struct Report {
    // Mrinaal: For simplicity, keeping everything as string for now
    /* mapping (uint => string) vitals; */
    /* mapping (uint => string) prescriptions; */
    /* uint numVitals; */
    /* uint numPrescriptions; */
    string vitals;
    string prescriptions;

    string symptoms;
  }

  struct Appointment {
    string timeOfAppointment;
    uint year;
    uint month;
    uint day;
    string location;
  }

  mapping (uint => Report) myReports;
  uint numReports = 0;


  // Data members required for a Doctor
  bool isDoctor = false;

  constructor (address _addr, uint _uid, bool _isDoctor) public {
    myAddr = _addr;
    myUID = _uid;
    isDoctor = _isDoctor;
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
    return (myReports[numReports].vitals, myReports[numReports].prescriptions, myReports[numReports].symptoms);
  }

  function getReportByID (uint reportID) public view returns(string memory, string memory, string memory) {
    require(reportID>=1 && reportID<=numReports, "The report with the given Report ID does not exist.");

    return (myReports[reportID].vitals, myReports[reportID].prescriptions, myReports[reportID].symptoms);
  }

  function getNumReports () public view returns(uint) {
    return numReports;
  }

  function getName () public view returns(string memory) {
    return name;
  }

  function getUID () public view returns(uint) {
    return myUID;
  }

  function updateReportWithUID(uint reportID, string memory vitals, string memory prescriptions, string memory symptoms) public {
    require(reportID>=1 && reportID<=numReports, "The report with the given Report ID does not exist.");

    myReports[reportID].vitals = vitals;
    myReports[reportID].prescriptions = prescriptions;
    myReports[reportID].symptoms = symptoms;
  }

}
