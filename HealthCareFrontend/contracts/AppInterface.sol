pragma solidity >=0.5.0 <0.6.0;

import "./Person.sol";

contract AppInterface {

  // Address of the admin/app-interface instance
  address admin;

  mapping (uint => Person) person;
  mapping (address => bool) isRegistered;
  mapping (address => uint) personToUID;

  uint numPersons = 0;


  constructor () public {
    admin = msg.sender;
  }

  event personRegistered(address personContractAddr, uint personUID);

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

  function isPersonRegistered () public view returns(bool) {
    return isRegistered[msg.sender];
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

}
