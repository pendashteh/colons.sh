#!/usr/bin/env bash

declare -A _CLASS_DATA

####
# Usage:
#   student=$(new Student)
####
new() {
  local class=$1
  local index=1
  [ ! -z "${_CLASS_DATA[${class},index]}" ] && $index=$(( 1 + ${_CLASS_DATA[$class,index]} ))
  local objref=${class}__$index
  _CLASS_DATA[${class},index]=$index
  echo $objref
}

####
# Usage:
#   :: student.__set name 'Robert'
#   name=$(:: student.__get name)
####
::() {
  [[ "$1" =~ (.*)\.(.*) ]]
  if [ "${#BASH_REMATCH[@]}" -eq 3 ]; then
    local args=${@:2}
    local object_name=${BASH_REMATCH[1]}
    local method=${BASH_REMATCH[2]}
    if [ $object_name = 'this' ]; then
      [ -z "$this" ] && echo 'Usage of this outside context.' && return 1
    else
      local objref=${!object_name}
      [ -z "$objref" ] && echo $object_name' is not an object.' && return 1
      local class=$(::get_class $objref)
      _class_load $class
      this=$objref
    fi
    $method $args
  fi
  [ -z $BASH_REMATCH[1] ] && echo 'Object not defined' && return
}
::set() {
  local objref=$1
  local prop=$2
  local value=$3
  local -A data=()
  _CLASS_DATA[$objref,$prop]=$value
}
::get() {
  local objref=$1
  local prop=$2
  echo ${_CLASS_DATA[$objref,$prop]}
}
::get_class() {
  local objref=$1
  [[ $objref =~ ^(.*)\_\_.*$ ]] && echo ${BASH_REMATCH[1]}
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
    ::get $this $prop
  }

  __set() {
    local prop=$1
    local val=$2
    ::set $this $prop $val
  }
}
