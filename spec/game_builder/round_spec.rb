require 'game_builder/round'

module GameBuilder

  describe Round do
    subject { Round.new("category_array") }

    it { is_expected.to respond_to(:categories) }

    let :round1 do
      Round.new([Category.new("name", [Clue.new("a", "b", 1)]), Category.new("eman", [Clue.new("c", "d", 2)])])
    end

    let :round2 do
      Round.new([Category.new("eman", [Clue.new("c", "d", 2)]), Category.new("name", [Clue.new("a", "b", 1)])])
    end

    let :round3 do
      Round.new([Category.new("name", [Clue.new("a", "b", 1)]), Category.new("eman", [Clue.new("c", "d", 2)])])
    end

    it "should only be equal with another round if they have the same content" do
      expect(round1).to eql(round3)
      expect(round1).not_to eql(round2)
    end
  end
end
