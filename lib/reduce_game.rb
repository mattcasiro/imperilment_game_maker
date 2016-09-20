require 'game_submitter/category_selector'
require 'game_submitter/clue_selector'
require 'constants'

class ReduceGame
  def reduce game
    # Determine the difficult for selecting the first category
    i = (DIFFICULTY == :easy || DIFFICULTY == :medium) ? 0 : 1

    # Reduce game to three cleaned categories

    rounds = [
      r1 = GameSubmitter::CategorySelector.new(game.rounds[i]).category,
      GameSubmitter::CategorySelector.new(game.rounds[1]).category(r1),
      GameSubmitter::CategorySelector.new(game.rounds[2], true).final_category,
    ]

    # Reduce categories to three clues
    rounds.map.with_index(1) do |category, i|
      clues = GameSubmitter::ClueSelector.new(category.clues).select_clues
      if i < 2
        clues[0].value = i * 200
        clues[1].value = i * 600
        clues[2].value = i * 1000
      end
      GameBuilder::Category.new category.name, clues
    end
  end
end
