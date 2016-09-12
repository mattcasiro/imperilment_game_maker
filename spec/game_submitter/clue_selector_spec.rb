require 'game_submitter/clue_selector'

module GameSubmitter
  describe ClueSelector do
    let(:selector) { ClueSelector.new([:c1, :c2, :c3, :c4, :c5]) } 

    context "Given five clues" do
      it { expect(selector.clues).to be_an_instance_of(Array) }
      it { expect(selector.clues.size).to be(3) }
      it { expect(selector.clues).to eql([:c1, :c2, :c3]) }
    end

    context "Given different difficulties" do
      it { expect(selector.clues(:easy)).to eql([:c1, :c2, :c3]) }
      it { expect(selector.clues(:medium)).to eql([:c3, :c4, :c5]) }
      it { expect(selector.clues(:hard)).to eql([:c3, :c4, :c5]) }
      it { expect{ selector.clues(:other) }.to raise_error(ArgumentError) }
    end
  end
end
