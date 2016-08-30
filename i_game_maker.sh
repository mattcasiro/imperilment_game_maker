if [ $# == 4 ]; then
  ruby -I ./lib -I . submit_game.rb $1 $2 $3 $4
else
  echo "Usage: bash i_game_maker.sh <num games> <start date (YYYY-MM-DD)> <user> <pwd>"
fi
