dir = File.expand_path(File.dirname(__FILE__)) + "/lib"
$LOAD_PATH.unshift(dir) unless $LOAD_PATH.include? dir

require 'build_game'
require 'game_submitter/clean_game'
require 'game_submitter/imperilment_communicator'
require 'constants'
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
  while !date.monday?
    date = date + 1.day
  end
  date
end

validate_parameters

# Ensure address is http:// prefixed
if ARGV[0]
  ARGV[0] = "http://" + ARGV[0] unless ARGV[0]&.index("http://")
  ARGV[0] = URI ARGV[0]
end

# Isolate parameters for comm instantiation
params = ARGV - [ARGV[3], ARGV[4]]

# Determine number of games to post
num_games = ARGV[3] ? ARGV[3].to_i : 1

# Determine start_date for the first game
date = if !ARGV[4]
         GameSubmitter::ImperilmentCommunicator.new(*params).last_game_date.to_s
       else
         ARGV[4]
       end
date = next_monday Date.strptime(date)

gb = BuildGame.new

(1..num_games).map do |i|
  i_game = begin
    # Scrape games from JArchive
    game = gb.next_game!

    # Prepare game for Imperilment submission
    case DIFFICULTY
      when :easy
       GameSubmitter::EasyGame.new(game)
      when :medium
       GameSubmitter::MediumGame.new(game)
      when :hard
       GameSubmitter::HardGame.new(game)
      else
        raise RuntimeError, "Difficulty is not set properly"
      end.categories
  rescue DuplicateGameError, ArgumentError
    retry
  end

  # Submit game to imperilment server
  comm = GameSubmitter::ImperilmentCommunicator.new(*params)
  gid = comm.create_game(date + 6.days)
  i_game.map do |category|
    cid = comm.create_category(category.name)
    category.clues.each do |clue|
      comm.create_answer gid, cid, clue.question, clue.answer, clue.value, date
      date = date + 1.day
    end
  end
end
