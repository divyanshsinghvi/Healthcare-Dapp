pragma solidity >=0.5.0 <0.6.0;

contract Person {

  address myAddr;
  uint myUID;

  struct Report {
    mapping (string => string) vitals;
    mapping (string => string) prescriptions;
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

  constructor(address _addr, uint _uid, bool _isDoctor) public {
    myAddr = _addr;
    myUID = _uid;
    isDoctor = _isDoctor;
  }
}
