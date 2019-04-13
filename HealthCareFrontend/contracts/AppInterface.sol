pragma solidity >=0.5.0 <0.6.0;

import "./Person.sol";

contract AppInterface {

  // Address of the admin/app-interface instance
  address admin;

  mapping (uint => Person) person;
  mapping (address => bool) isRegistered;
  
  uint numPersons = 0;


  constructor() public {
    admin = msg.sender;
  }

  event personRegistered(address personContractAddr, uint personUID);

  modifier onlyAdmin {
    require(msg.sender == admin, "You are not authorized for this!!!");
    _;
  }

  function registerPerson(bool _isDoctor) public {
    numPersons++;
    person[numPersons] = new Person(msg.sender, numPersons, _isDoctor);
    isRegistered[msg.sender] = true;

    emit personRegistered(address(person[numPersons]), numPersons);
  }

  function isPersonRegistered () public view returns(bool) {
    emit personRegistered(address(person[numPersons]), numPersons);
    return isRegistered[msg.sender];
  }
  
}
