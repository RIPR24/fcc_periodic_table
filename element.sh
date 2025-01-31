#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELE=$($PSQL "SELECT elements.atomic_number,symbol,name,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE atomic_number = $1;")
  else
    ELE=$($PSQL "SELECT elements.atomic_number,symbol,name,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE symbol = '$1' OR name = '$1';")
  fi
  if [[ -z $ELE ]]
  then
    echo I could not find that element in the database.
  else
    echo "$ELE" | while IFS='|' read AN SY NAME TYPE AM MP BP
    do
      echo "The element with atomic number $AN is $NAME ($SY). It's a $TYPE, with a mass of $AM amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
    done
  fi
fi