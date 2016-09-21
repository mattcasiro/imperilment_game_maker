[![license](https://img.shields.io/badge/License-MIT-brightgreen.svg?maxAge=604800)](https://opensource.org/licenses/MIT)
[![ruby](https://img.shields.io/badge/Ruby-2.3.1-blue.svg?maxAge=604800)](https://opensource.org/licenses/MIT)
[![version](https://img.shields.io/badge/Version-1.0.1-blue.svg?maxAge=604800)](https://opensource.org/licenses/MIT)

# Imperilment Game Maker

Build a game of Imperilment from data scraped off of [J! Archive](http://j-archive.com/), and submit the game to an Imperilment web server.

# Usage
### Fully Automated Functionality
The entire game generation and submission process can be run using the **Submit Game** script:
```
ruby submit_game.rb <http://host:port> <user> <pwd> [ <num_games> <start_date> ]
```
* `num-games` defaults to 1 if ommitted, and can be used to submit multiple games at once  
* `start_date` defaults to the first Monday on or after today's date
* This process can easily be automated, see [config/schedule.rb](https://github.com/Zullybur/jeopardy_game_maker/blob/master/config/schedule.rb)

### Configuration Settings
Some configuration settings are available in [lib/constants.rb](https://github.com/Zullybur/jeopardy_game_maker/blob/master/lib/constants.rb):
* Difficulty: `DIFFICULTY = [ :easy | :medium | :hard ]`
* Seasons: `SEASONS = [ :all | 1 | 2 | 3... ]`
See the file comments for descriptions of these settings.

### Manual Game Creation
A full game of Jeopardy can be created using the [Game Builder](https://github.com/Zullybur/jeopardy_game_maker/blob/master/lib/build_game.rb):
```ruby
require 'build_game'      # Assumes /lib is in $LOAD_PATH

gb = BuildGame.new        # A single object prevents the application from returning
game = begin              # duplicate games within one session, if mutliple games
  gb.next_game!           # are desired. Place the begin block inside a loop
rescue DuplicateGameError # to iterate and return as many games as needed.
  retry
end
```
* `BuildGame.new` accepts an optional parameter `user_paths [Array]`, containing defined sources for game creation
  * Path can be a local *HTML* file, or specific *J! Archive* link
  * `next_game!` will raise `ArgumentError` if called more times than the size of the `user_paths` array
  * `next_game!` will raise `DuplicateGameError` if trying to parse the same source multiple times
  * `next_game!` will raise `MissingRoundError` if the source does not contain three valid rounds

### Manual Game Reduction
A full game of Jeopardy can be reduced to fit the Imperilment format* using the [Game Reducer](https://github.com/Zullybur/jeopardy_game_maker/blob/master/lib/reduce_game.rb), which randomly selects categories and deterministically selects clues from those categories.
```ruby
require 'reduce_game'     # Assumes /lib is in $LOAD_PATH

i_game = ReduceGame.new.reduce(game)
```
* Reduce Game has side effects on the game content (but does not alter the original object passed in):
  * Nils out clue content containing links or video double jeopardy
  * Removes HTML tags, backslashes, and double spaces from clue content
  * Removes clues containing nil content from categories
* Reduce Game can throw errors depending on the content remaining after the side effects are applied
  * ArgumentError if the round does not have enough valid categories to be used
  * RuntimeError if the Final Jeopardy round does not contain exactly one category with exactly one clue

### Manual Game Submission
A properly reduced game of Imperilment can be submitted to an Imperilment web server using the REST API:
```ruby
require 'game_submitter/imperilment_communicator'
require 'active_support/core_ext/numeric/time'

comm = GameSubmitter::ImperilmentCommunicator.new uri, user, pwd

# Date parameter should be a monday
gid = comm.create_game(date + 6.days)         # date parameter should be set to a monday
i_game.map do |category|                      # create_game can also be called without a date
  cid = comm.create_category(category.name)   # as long as one game already exists on the server,
  category.clues.each do |clue|               # in which case, 
    comm.create_answer gid, cid, clue.answer, clue.question, clue.value, date
    date = date + 1.day
  end
end
```
* `date` must be a monday for games to populate properly
* `create_game` can be called without any parameters as long as there is a pre-existing game on the web server, in which case the current game will occupy the week following the most recent game
  * Ensure `date` properly lines up in this case, or answers may not populate properly in views

#### *Imperilment Format:
 * Three rounds
 * One category per round
 * Three clues in the first two categories
   * Single Jeopardy ($200, $600, $1000)
   * Double Jeopardy ($400, $1200, $2000)
 * One clue clue in the final category *with no value*
 * Clues will be excluded if they are
   * Video Daily Double clues
   * Clues with links to media (picture clues, video clues, audio clues, etc)

### Development
* Source is hosted on [GitHub](https://github.com/Zullybur/jeopardy_game_maker)
* Report issues on GitHub(https://github.com/Zullybur/jeopardy_game_maker/issues)
* Make change requests on GitHub(https://github.com/Zullybur/jeopardy_game_maker/issues)
