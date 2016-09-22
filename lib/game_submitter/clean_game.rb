require 'game_submitter/clean_round'
require 'constants'
require 'pry'

module GameSubmitter
  class CleanGame
    def initialize game
      @game = game
    end

    def rounds
      @rounds ||= [
        CleanRound.new(game.rounds[0].categories),
        CleanRound.new(game.rounds[1].categories),
      ]
    end

    def final_round
      CleanFinalRound.new(game.rounds[2].categories)
    end

    protected
    def set_values clues, multiplier
      clues[0].value = multiplier * 200
      clues[1].value = multiplier * 600
      clues[2].value = multiplier * 1000
      clues
    end

    private
    attr_reader :game
  end

  class EasyGame < CleanGame
    def categories
      rounds.map.with_index(1) do |round, i|
        ctgry = round.categories.sample
        GameBuilder::Category.new(ctgry.name, select_clues(ctgry.clues, i))
      end + [ final_round.categories.first ]
    end

    protected
    def select_clues all_clues, i
      set_values all_clues[0..2], i
    end
  end

  class MediumGame < EasyGame
    protected
    def select_clues all_clues, i
      set_values all_clues[(all_clues.size - 3)..-1], i
    end
  end

  class HardGame < MediumGame
    def categories
      if rounds[1].categories.size < 2
        raise ArgumentError, "Insufficient valid categories in Double Jeopardy"
      end

      rounds[1].categories.sample(2).sort.map.with_index(1) do |ctgry, i|
        GameBuilder::Category.new(ctgry.name, select_clues(ctgry.clues, i))
      end + [ final_round.categories.first ]
    end
  end
end
