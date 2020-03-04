#!/usr/bin/env bash

. ../colons.sh

new Student as ali
$ali.ask_name

new Person as pedram
$pedram.ask_name

new Student as reza
$reza.__set name 'Reza'

$ali.welcome
$pedram.welcome
$reza.welcome
