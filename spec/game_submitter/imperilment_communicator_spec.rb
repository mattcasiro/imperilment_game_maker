require 'game_submitter/imperilment_communicator'
require 'vcr_setup'

module GameSubmitter
  RSpec::Matchers.define :not_eql do |expected|
    match do |actual|
      actual != expected
    end
  end

  describe ImperilmentCommunicator do
    before(:context) do
      @user = "admin@example.com"
      @pwd = "test123"
      @uri = URI "http://localhost:3000"
    end

    context "#create_game", vcr: true do
      let(:comm) { ImperilmentCommunicator.new(@uri, @user, @pwd) }
      let(:result) { comm.create_game }

      it { expect{ result }.not_to raise_error }
      it { expect(result).to not_eql(0).and not_eql(nil) }
    end

    context "#create_category", vcr: true do
      let(:comm) { ImperilmentCommunicator.new(@uri, @user, @pwd) }
      let(:result) { comm.create_category "rspec test category" }

      it { expect{ result }.not_to raise_error }
      it { expect(result).to not_eql(0).and not_eql(nil) }
    end

    context "#create_answer", vcr: true do
      let(:comm) { ImperilmentCommunicator.new(@uri, @user, @pwd) }
      let(:gid) { comm.create_game }
      let(:cid) { comm.create_category "rspec test category" }
      let(:ans) { "Rspec test answer" }
      let(:que) { "Rspec test question" }
      let(:val) { 100 }
      let(:start_date) { Date.new(9999, (rand(11) + 1), (rand(27) + 1)) }
      let(:result) { comm.create_answer gid, cid, ans, que, val, start_date }

      it { expect{ result }.not_to raise_error }
      it { expect(result).to not_eql(0).and not_eql(nil) }
    end
  end
end
