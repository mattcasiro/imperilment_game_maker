require 'game_submitter/clue_selector'
require 'game_builder/scraper'
require 'constants'

module GameSubmitter
  describe ClueSelector do
    context "Given five clues" do
      let(:clues) { GameBuilder::Scraper.new.new_game!(FIXTURE_PATH + "show_465_id_4788.html").rounds[0].categories[3].clues }
      let(:selector) { ClueSelector.new(clues) } 

      it { expect(selector.select_clues).to be_an_instance_of(Array) }
      it { expect(selector.select_clues.size).to be(3) }
      it { expect(selector.select_clues).to eql(clues[0..2]) }
    end

    context "Given different difficulties" do
      let(:clues) { GameBuilder::Scraper.new.new_game!(FIXTURE_PATH + "show_465_id_4788.html").rounds[0].categories[3].clues }
      let(:selector) { ClueSelector.new(clues) } 

      it { expect(selector.select_clues(:easy)).to eql(clues[0..2]) }
      it { expect(selector.select_clues(:medium)).to eql(clues[2..4]) }
      it { expect(selector.select_clues(:hard)).to eql(clues[2..4]) }
      it { expect{ selector.select_clues(:ez) }.to raise_error(ArgumentError) }
    end
  end
end
