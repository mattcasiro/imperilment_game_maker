require 'game_submitter'

tmp = ARGV[2].split("-")
t = Time.new(tmp[0], tmp[1], tmp[2])
GameSubmitter.new.submit_games ARGV[0], ARGV[1].to_i, t, ARGV[3], ARGV[4]
