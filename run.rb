require 'i_game_maker'

tmp = ARGV[1].split("-")
t = Time.new(tmp[0], tmp[1], tmp[2])
IGameMaker.new.submit_games ARGV[0].to_i, t
