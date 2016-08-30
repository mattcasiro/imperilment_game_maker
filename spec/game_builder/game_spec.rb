require 'game_builder/game'

module GameBuilder

  describe Game do
    subject { Game.new("source", "rounds") }

    it { is_expected.to respond_to(:source) }
    it { is_expected.to respond_to(:rounds) }

    let :round1 do
      Round.new([Category.new("name", [Clue.new("a", "b", 1)]), Category.new("eman", [Clue.new("c", "d", 2)])])
    end

    let :round2 do
      Round.new([Category.new("eman", [Clue.new("c", "d", 2)]), Category.new("name", [Clue.new("a", "b", 1)])])
    end

    let(:game1) { Game.new("source", [:round1, :round2]) }
    let(:game2) { Game.new("SOURCE", [:round2, :round1]) }
    let(:game3) { Game.new("source", [:round1, :round2]) }

    it "should only be equal with another game if they have the same content" do
      expect(game1).to eql(game3)
      expect(game1).not_to eql(game2)
    end
  end
end
