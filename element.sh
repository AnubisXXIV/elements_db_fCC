#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# if not argument was given
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
#argument was given
else
  #check if input is a number
  NUMBER_REGEX='^[0-9]+$'
  if [[ $1 =~ $NUMBER_REGEX ]]
  then
    QUERY_RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
  # input is not a number
  else
    QUERY_RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1' OR name = '$1'")
  fi
  #check for everything in one command
  
  #if not found return error
  if [[ -z $QUERY_RESULT ]]
  then
    echo "I could not find that element in the database."
    exit 0
  fi

  RESULT=$($PSQL "SELECT * FROM elements LEFT JOIN properties USING (atomic_number) LEFT JOIN types USING (type_id) WHERE atomic_number=$QUERY_RESULT")
  IFS="|" read -r TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE <<< "$(echo $RESULT)"
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
fi