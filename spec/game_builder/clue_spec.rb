require 'game_builder/clue'

module GameBuilder

  describe Clue do
    subject { Clue.new("question", "answer", 100) }

    it { is_expected.to respond_to(:question) }
    it { is_expected.to respond_to(:answer) }
    it { is_expected.to respond_to(:value) }

    let(:clue1){ Clue.new("a", "b", 1) }
    let(:clue2){ Clue.new("c", "d", 2) }
    let(:clue3){ Clue.new("a", "b", 1) }

    it "should only be equal with another clue if they have the same content" do
      expect(clue1).to eql(clue3)
      expect(clue1).not_to eql(clue2)
    end
  end
end
