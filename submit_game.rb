require 'game_submitter'

tmp = ARGV[1].split("-")
t = Time.new(tmp[0], tmp[1], tmp[2])
GameSubmitter.new.submit_games ARGV[0].to_i, t, ARGV[2], ARGV[3]
