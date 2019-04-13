pragma solidity >=0.5.0 <0.6.0;

import "./Person.sol";

contract AppInterface {

  // Address of the admin/app-interface instance
  address admin;

  mapping (uint => Person) person;
  uint numPersons = 0;


  constructor() public {
    admin = msg.sender;
  }

  event personRegistered(address personAddr, int personUID);

  modifier onlyAdmin {
    require(msg.sender == admin, "You are not authorized for this!!!");
    _;
  }

  function registerPerson(address _personAddr, bool _isDoctor) onlyAdmin public {
    numPersons++;
    person[numPersons] = new Person(_personAddr, numPersons, _isDoctor);
  }
}
