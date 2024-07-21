#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
RANDOM_NUMBER=$(( $RANDOM%1000 + 1))
echo "Enter your username:"
read NAME
USERNAME=$($PSQL "SELECT username FROM data WHERE username = '$NAME'")
BEST_GAME=$($PSQL "SELECT best_game FROM data WHERE username = '$NAME'")
if [[ -z $USERNAME ]] 
then
echo "Welcome, $NAME! It looks like this is your first time here."
insert_name=$($PSQL "INSERT INTO data(username, games_played) VALUES('$NAME', 1)")
else
GAMES_PLAYED=$($PSQL "SELECT games_played FROM data WHERE username = '$NAME'")
echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
new=$(( $GAMES_PLAYED + 1 ))
update=$($PSQL "UPDATE data SET games_played = $new WHERE username = '$USERNAME'")
fi

echo "Guess the secret number between 1 and 1000:"


guess=1
flag=true
while [[ $flag == true ]]
do
read INPUT
if [[ $INPUT =~ [0-9] ]]
then
if [[ $INPUT -lt $RANDOM_NUMBER ]]
then
echo "It's lower than that, guess again:"
(( guess++ ))
fi
if [[ $INPUT -gt  $RANDOM_NUMBER ]]
then
echo "It's higher than that, guess again:"
(( guess++ ))
fi
if [[ $INPUT -eq $RANDOM_NUMBER ]]
then
echo "You guessed it in $guess tries. The secret number was $RANDOM_NUMBER. Nice job!"
if [[ -z $BEST_GAME ]]
then
update=$($PSQL "UPDATE data SET best_game = $guess WHERE username = '$NAME'")
else
if [[ $BEST_GAME -gt $guess ]]
then
redate=$($PSQL "UPDATE data SET best_game = $guess WHERE username = '$USERNAME'")
fi
fi
flag=false
fi
else
echo "That is not an integer, guess again:"
fi
done
