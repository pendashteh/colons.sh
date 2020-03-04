#!/usr/bin/env bash

class Person && {

  function ask_name {
    read -p 'What is the name of this person? ' input
    $this.__set name $input
  }

  function welcome {
    echo "Welcome "$($this.__get name)
  }
}
