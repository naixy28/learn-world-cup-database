#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
$PSQL "TRUNCATE teams, games;"
tail -n +2 games.csv | while IFS="," read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  TEAM_EXISTS=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
  # echo exist? $TEAM_EXISTS
  if [[ -z $TEAM_EXISTS ]]
  then
    # echo insert $WINNER
    $PSQL "INSERT INTO teams(name) VALUES ('$WINNER')"
  fi
  TEAM_EXISTS=$($PSQL "SELECT * FROM teams WHERE name = '$OPPONENT'")
  # echo current $WINNER
  if [[ -z $TEAM_EXISTS ]]
  then
    # echo insert $WINNER
    $PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')"
  fi

  WID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
  OID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
  $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WID, $OID, $WINNER_GOALS, $OPPONENT_GOALS)"
  
done