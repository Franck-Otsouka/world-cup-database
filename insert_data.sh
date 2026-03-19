#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# clear tables (important for tests)
echo $($PSQL "TRUNCATE games, teams RESTART IDENTITY")

while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OGOALS
do
  if [[ $YEAR != "year" ]]
  then

    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'" | xargs)

    if [[ -z $WINNER_ID ]]
    then
      $PSQL "INSERT INTO teams(name) VALUES('$WINNER')"
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'" | xargs)
    fi


    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'" | xargs)

    if [[ -z $OPPONENT_ID ]]
    then
      $PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')"
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'" | xargs)
    fi


    $PSQL "INSERT INTO games(
      year,
      round,
      winner_id,
      opponent_id,
      winner_goals,
      opponent_goals
    ) VALUES(
      $YEAR,
      '$ROUND',
      $WINNER_ID,
      $OPPONENT_ID,
      $WGOALS,
      $OGOALS
    )"

  fi
done < games.csv
