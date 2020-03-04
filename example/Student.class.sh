#!/usr/bin/env bash


class Student extends Person && {

  declare -i student_number=0

  function __construct {
    $this.__set student_number $((student_number+=1))
  }

  function welcome {
    printf 'Welcome student #%s %s\n' $($this.__get student_number) $($this.__get name)
  }
}
