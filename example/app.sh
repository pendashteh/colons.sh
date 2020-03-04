#!/usr/bin/env bash

. ../colons.sh

ali=$(new Student)
$ali.ask_name

pedram=$(new Person)
$pedram.ask_name

$ali.welcome
$pedram.welcome
