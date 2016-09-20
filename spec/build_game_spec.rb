require 'build_game'
require 'constants'

describe BuildGame do
  let(:path) { FIXTURE_PATH }

  context "Given the wrong number of sources" do
    let(:gb) { BuildGame.new([path + "/show_465_id_4788.html"]) }
    
    it { expect { gb.next_game!; gb.next_game! }.to raise_error(ArgumentError) }
  end

  context "Given a source with missing rounds" do
    let(:gb) { BuildGame.new([path + "show_366_id_4284.html"]) }
    it "raises a MissingRoundError" do
      expect{ gb.next_game! }. to raise_error(GameBuilder::MissingRoundError)
    end
  end

  context "given two games" do
    let(:sources) { [
      path + "show_465_id_4788.html",
      path + "show_2121_id_1426_S10.html",
    ] }
    let(:gb) { BuildGame.new(sources) }

    before(:each) { gb.next_game!; gb.next_game! }

    it { expect(gb.games.size).to eql(2) }
  end

  context "given two of the same games" do
    let(:sources) { [
      path + "show_465_id_4788.html",
      path + "show_465_id_4788.html",
    ] }
    let(:gb) { BuildGame.new(sources) }

    it { expect{ gb.next_game!; gb.next_game! }.to raise_error(DuplicateGameError) }
  end
end
