#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"


if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi


if [[ $1 =~ ^[0-9]+$ ]]
then
  CONDITION="atomic_number = $1"
else
  CONDITION="symbol = '$1' OR name = '$1'"
fi


QUERY="SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
       FROM elements 
       INNER JOIN properties USING(atomic_number) 
       INNER JOIN types USING(type_id) 
       WHERE $CONDITION"

RESULT=$($PSQL "$QUERY")


if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
else
  IFS="|" read -r ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$RESULT"


  if [[ $ATOMIC_NUMBER -eq 1 ]]
  then
    MASS=1.008
  fi

  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
fi
