if [ $# == 4 ]; then
  ruby -I ../j_game_maker/ -I ../j_game_maker/lib -I ./lib run.rb $1 $2 $3 $4
else
  echo "Usage: bash i_game_maker.sh <num games> <start date> <user> <pwd>"
fi
