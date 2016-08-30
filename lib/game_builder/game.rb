require 'game_builder/round'

module GameBuilder
  class Game
    attr_reader :source, :rounds

    # Generates a Game object
    #
    # @param source [String] is the path to the source file or resource
    # @param rounds [Round[]] is an array of rounds
    def initialize(source, rounds)
      @source = source
      @rounds = rounds
    end

    # Compare games based on whether the rounds are equal (eql?)
    #
    # @param other [Game] is a Game object to compare to
    def eql?(other)
      return false unless other.is_a?(Game)
      self.rounds == other.rounds
    end
  end
end
