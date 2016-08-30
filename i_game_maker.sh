if [ $# == 5 ]; then
  ruby -I ./lib -I . submit_game.rb $1 $2 $3 $4 $5
else
  echo "Usage: bash i_game_maker.sh <http://host:port> <num games> <start date (YYYY-MM-DD)> <user> <pwd>"
fi
