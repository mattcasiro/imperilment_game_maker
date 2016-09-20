require 'reduce_game'
require 'constants'

describe ReduceGame do
  let(:path) { FIXTURE_PATH }

  context "given a complete game" do
    let(:game) { BuildGame.new([path + "/show_465_id_4788.html"]).next_game! }
    subject { ReduceGame.new.reduce(game) }

    it "shoule build an array of three categories" do
      stub_const("DIFFICULTY", :easy)
      expect(subject.size).to eql(3)
      expect(subject[0]).to be_a(GameBuilder::Category)
      expect(subject[1]).to be_a(GameBuilder::Category)
      expect(subject[2]).to be_a(GameBuilder::Category)
    end

    it "should have three clues in the first two categories" do
      stub_const("DIFFICULTY", :easy)
      expect(subject[0].clues.size).to eql(3)
      subject[0].clues.each { |clue| expect(clue).to be_a(GameBuilder::Clue) }
      expect(subject[1].clues.size).to eql(3)
      subject[1].clues.each { |clue| expect(clue).to be_a(GameBuilder::Clue) }
    end

    it "should have one clue in the final categorie, with a nil value" do
      stub_const("DIFFICULTY", :easy)
      expect(subject[2].clues.size).to eql(1)
      expect(subject[2].clues[0]).to be_a(GameBuilder::Clue)
      expect(subject[2].clues[0].value).to eql(nil)
    end
  end
end
