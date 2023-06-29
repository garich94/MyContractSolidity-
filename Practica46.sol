// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Moods {
  enum Mood {Surprise, Sadness, Disgust, Fear, Happiness, Anger}
  Mood public currentMood;
  uint public counter;

  function setMood(Mood _mood) public {
    currentMood = _mood;
  }

  modifier checkMood(Mood _expertedMood) {
      require(_expertedMood == currentMood, "Wrong Mood!");
      _;
  }

  function someAction(Mood _expertedMood) public checkMood(_expertedMood) {
      counter++;
  }
}  