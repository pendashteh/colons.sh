#!/usr/bin/env bash

class Student extends Person && {

  function welcome {
    echo "Welcome student "$($this.__get name)
  }
}
