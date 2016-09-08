dir = File.expand_path(File.dirname(__FILE__)) + "/lib"
$LOAD_PATH.unshift(dir) unless $LOAD_PATH.include? dir

require 'game_submitter'
require 'pry'

# Verify number of arguments
if ARGV.size < 3
  puts "Usage: bash i_game_maker.sh <http://host:port> <user> <pwd> [ <num games> <start date (YYYY-MM-DD)> ]"
  exit
end

# Verify number of games is valid
if !ARGV[3].nil?
  @games = ARGV[3].to_i unless ARGV[3].nil?
  if @games <= 0
    puts "Number of games must be greater than or equal to zero"
    exit
  end
end

# Verify start date is valid date
if !ARGV[4].nil?
  date_array = ARGV[4].split("-")
  if date_array.include?(0)
    puts "Date must be in the format YYYY-MM-DD"
    exit
  elsif !date_array[0].between?(1000, 9999)
    puts "Year must be four digits (YYYY)"
    exit
  elsif !date_array[1].between?(1, 12)
    puts "Month must be between 1 and 12"
    exit
  elsif !date_array[0].between?(1, 31)
    puts "Day must be between 1 and 31"
    exit
  else
    @start = Time.new(date_array[0], date_array[1], date_array[2])
  end
end

if @games && @start
  GameSubmitter.new ARGV[0], ARGV[1], ARGV[2], @games, @start
elsif @games
  GameSubmitter.new ARGV[0], ARGV[1], ARGV[2], @games
else
  GameSubmitter.new ARGV[0], ARGV[1], ARGV[2]
end
