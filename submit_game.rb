dir = File.expand_path(File.dirname(__FILE__)) + "/lib"
$LOAD_PATH.unshift(dir) unless $LOAD_PATH.include? dir

require 'build_game'
require 'reduce_game'
require 'game_submitter/imperilment_communicator'
require 'active_support/core_ext/numeric/time'

def validate_parameters
  # Verify number of arguments
  if !ARGV.size.between?(3, 5)
    raise ArgumentError, "Usage: ruby submit_game.rb " +
    "<http://host:port> <user> <pwd> [ <num games> <start date (YYYY-MM-DD)> ]"
  end

  # Verify number of games is valid
  if ARGV[3]&.to_i == 0
    raise ArgumentError, "Number of games must be greater than or equal to zero"
  end

  # Verify start date is valid date
  if date_array = ARGV[4]&.split("-")
    if date_array.include?(0) || date_array.size != 3
      raise ArgumentError, "Date must be in the format YYYY-MM-DD"
    elsif !date_array[0].to_i.between?(1000, 9999)
      raise ArgumentError, "Year must be four digits (YYYY)"
    elsif !date_array[1].to_i.between?(1, 12)
      raise ArgumentError, "Month must be between 1 and 12"
    elsif !date_array[2].to_i.between?(1, 31)
      raise ArgumentError, "Day must be between 1 and 31"
    end
  end
end

def next_monday date
  tmp = date.dup
  while !tmp.monday?
    tmp = tmp + 1.day
  end
  tmp
end

validate_parameters

# Ensure address is http:// prefixed
if ARGV[0]
  ARGV[0] = "http://" + ARGV[0] unless ARGV[0]&.index("http://")
  ARGV[0] = URI ARGV[0]
end

# Determine number of games to post
num_games = ARGV[3] ? ARGV[3].to_i : 1

# Isolate game specific parameters
params = ARGV - [ARGV[3], ARGV[4]]

gb = BuildGame.new
date = next_monday( ARGV[4] ? Time.parse(ARGV[4]) : Time.now )

(1..num_games).map do |i|
  # Scrape games from JArchive
  game = begin
    gb.next_game!
  rescue DuplicateGameError
    puts "Duplicate Game Error on iteration #{i}"
    retry
  end

  # Reduce game to Imperilment format
  begin
    i_game = ReduceGame.new.reduce(game)
  rescue ArgumentError
    puts "Argument Error on iteration #{i}"
    retry
  end

  # Submit game to imperilment server
  comm = GameSubmitter::ImperilmentCommunicator.new *params

  gid = comm.create_game(date + 6.days)
  i_game.map do |category|
    cid = comm.create_category(category.name)
    category.clues.each do |clue|
      comm.create_answer gid, cid, clue.answer, clue.question, clue.value, date
      date = date + 1.day
    end
  end
end
