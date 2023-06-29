// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBuilding {
  function isLastFloor(uint) external returns (bool);
}


contract Elevator {
  bool public top;
  uint public floor;

  function goTo(uint _floor) public {
    IBuilding building = IBuilding(msg.sender);

    if (! building.isLastFloor(_floor)) {
      floor = _floor;
      top = building.isLastFloor(floor);
    }
  }
}

contract Building {
    Elevator public elevator;
    uint public lastFloor = 100;

    constructor(address _elevator) {
        elevator = Elevator(_elevator);
    }

    function goToFlor(uint _floor) public {
        elevator.goTo(_floor);
    }

      function isLastFloor(uint _floor) external returns(bool) {
          if(lastFloor != _floor) {
              lastFloor = _floor;
              return false;
          }

          return true;
      }
 
}