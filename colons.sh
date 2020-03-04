#!/usr/bin/env bash

declare -A _CLASS_DATA

####
# Usage:
#   student=$(new Student)
#   $student.__set name 'Robert'
#   name=$($student.__get name)
####
new() {
  local class=$1
  local index=1
  [ ! -z "${_CLASS_DATA[${class},index]}" ] && $index=$(( 1 + ${_CLASS_DATA[$class,index]} ))
  local objref=${class}__$index
  _CLASS_DATA[${class},index]=$index
  ::get_executable $objref
}

####
# Retrieves object reference by the given object name
# Usage:
# $ ::objref this
# > MyObjectClassName__1233
####
::objref() {
  local varname=$1
  IFS=' ' read -a parts <<< ${!varname}
  echo ${parts[1]}
}
::get_executable() {
  local objref=$1
  local objfunc='::'
  [ ! -z "$2" ] && objfunc=$2
  echo $objfunc' '$objref
}

####
# Standard object executor
# This function is embedded in the variable names of Objects.
# You should not need to call this object directly
####
::() {
  IFS='.' read -a parts <<< $1
  if [ "${#parts[@]}" -eq 2 ]; then
    local args=${@:2}
    local objref=${parts[0]}
    local method=${parts[1]}
    if [ -z "$_IS_THIS" ]; then
      local class=$(::get_class $objref)
      _class_load $class
      this=$(::get_executable $objref '::this')
    fi
    $method $args
  fi
  [ -z $BASH_REMATCH[1] ] && echo 'Object not defined' && return
}

####
# Special object executer
# @description Executes methods in the context of 'this'
# @see ::()
####
::this() {
  _IS_THIS=1 :: ${@}
}
####
# Returns the class name by the given Object reference
# Usage:
#   class=$(::get_class $(::objref this))
####
::get_class() {
  local objref=$1
  IFS='__' read -a parts <<< $objref
  echo ${parts[0]}
}

##
# Usage:
#   class Base
#   class Person extends Base
#   class Student extends Person
class() {
  local class=$1
  [ "__BASE" = "$class" ] && return
  if [ ! "$CLASS_TO_LOAD" = "$class" ]; then
    return 1
  fi
  if [ "$2" = 'extends' ]; then
    local parent=$3
    _class_load $parent
  fi
  CLASS_LOADED=$class
}
_class_get_path() {
  local class=$1
  printf '%s.class.sh' $class
}
_class_load() {
  local class=$1
  local path=$(_class_get_path $class)
  [ ! -e $path ] && echo 'Failed to load class '$class && exit
  unset CLASS_LOADED
  CLASS_TO_LOAD=$class . $path
  [ ! "$CLASS_LOADED" = "$class" ] && echo 'Implementation not found for class '$class && exit
}

# Every class extends __BASE by default
class __BASE && {

  __get() {
    local prop=$1
    local objref=$(::objref this)
    echo ${_CLASS_DATA[$objref,$prop]}
  }

  __set() {
    local prop=$1
    local value=$2
    IFS=' ' read -a parts <<<"$this"
    local objref=$(::objref this)
    _CLASS_DATA[$objref,$prop]=$value
  }
}
