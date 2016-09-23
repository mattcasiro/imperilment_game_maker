require 'game_submitter/imperilment_communicator'
require 'vcr_setup'
require 'pry'

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

      it { expect(result).to not_eql(0).and not_eql(nil) }
    end

    context "get /games/new fails" do
      let(:comm) { ImperilmentCommunicator.new(@uri, @user, @pwd) }
      let(:date) { Time.new(2020, 01, 01) }
      after(:example) { WebMock.reset! }

      it "should raise a 'get' ResponseError" do
        VCR.turned_off do
          WebMock.stub_request(:get, "http://localhost:3000/games/new").
            to_return(body: '<meta name="csrf-token" content="token" />',
                      headers: { "set-cookie" => 'cookie' },
                      status: 302)
          WebMock.stub_request(:any, "http://localhost:3000/users/sign_in").
            to_return(body: '<meta name="csrf-token" content="token" />',
                      headers: {"set-cookie" => 'cookie'})

          expect{ comm.create_game(date) }.
            to raise_error(ResponseError, /get response/)
        end
      end
    end

    context "post /games fails" do
      let(:comm) { ImperilmentCommunicator.new(@uri, @user, @pwd) }
      let(:date) { Time.new(2020, 01, 01) }
      after(:example) { WebMock.reset! }

      it "should raise a 'post' ResponseError" do
        VCR.turned_off do
          WebMock.stub_request(:get, "http://localhost:3000/games/new").
            to_return(body: '<meta name="csrf-token" content="token" />',
                      headers: { "set-cookie" => 'cookie' },
                      status: 200)
          WebMock.stub_request(:any, "http://localhost:3000/users/sign_in").
            to_return(body: '<meta name="csrf-token" content="token" />',
                      headers: {"set-cookie" => 'cookie'})
          WebMock.stub_request(:post, "http://localhost:3000/games").
            to_return(body: '<meta name="csrf-token" content="token" />',
                      headers: {"set-cookie" => 'cookie', "location" => ["http://localhost:3000/games/1"], },
                      status: 200)

          expect{ comm.create_game(date) }.
            to raise_error(ResponseError, /post response/)
        end
      end
    end

    context "#create_category", vcr: true do
      let(:comm) { ImperilmentCommunicator.new(@uri, @user, @pwd) }
      let(:result) { comm.create_category "rspec test category" } 
      it { expect(result).to not_eql(0).and not_eql(nil) }
    end

    context "get /categories/new fails" do
      let(:comm) { ImperilmentCommunicator.new(@uri, @user, @pwd) }
      let(:name) { "Rspec Test Category" }
      after(:example) { WebMock.reset! }

      it "should raise a 'get' ResponseError" do
        VCR.turned_off do
          WebMock.stub_request(:get, "http://localhost:3000/categories/new").
            to_return(body: '<meta name="csrf-token" content="token" />',
                      headers: { "set-cookie" => 'cookie' },
                      status: 302)
          WebMock.stub_request(:any, "http://localhost:3000/users/sign_in").
            to_return(body: '<meta name="csrf-token" content="token" />',
                      headers: {"set-cookie" => 'cookie'})

          expect{ comm.create_category(name) }.
            to raise_error(ResponseError, /get response/)
        end
      end
    end

    context "post /categories fails" do
      let(:comm) { ImperilmentCommunicator.new(@uri, @user, @pwd) }
      let(:name) { "Rspec Test Category" }
      after(:example) { WebMock.reset! }

      it "should raise a 'post' ResponseError" do
        VCR.turned_off do
          WebMock.stub_request(:get, "http://localhost:3000/categories/new").
            to_return(body: '<meta name="csrf-token" content="token" />',
                      headers: { "set-cookie" => 'cookie' },
                      status: 200)
          WebMock.stub_request(:any, "http://localhost:3000/users/sign_in").
            to_return(body: '<meta name="csrf-token" content="token" />',
                      headers: {"set-cookie" => 'cookie'})
          WebMock.stub_request(:post, "http://localhost:3000/categories").
            to_return(body: '<meta name="csrf-token" content="token" />',
                      headers: {"set-cookie" => 'cookie', "location" => ["http://localhost:3000/categories/1"], },
                      status: 200)

          expect{ comm.create_category(name) }.
            to raise_error(ResponseError, /post response/)
        end
      end
    end

    context "#create_answer", vcr: true do
      let(:comm) { ImperilmentCommunicator.new(@uri, @user, @pwd) }
      let(:gid) { comm.create_game }
      let(:cid) { comm.create_category "rspec test category" }
      let(:ans) { "Rspec test answer" }
      let(:que) { "Rspec test question" }
      let(:val) { 100 }
      let(:start_date) { Date.new(9999, 1, 1) }
      let(:result) { comm.create_answer gid, cid, ans, que, val, start_date }

      it { expect(result).to not_eql(0).and not_eql(nil) }
    end

    context "get /games/1/answers/new fails" do
      let(:comm) { ImperilmentCommunicator.new(@uri, @user, @pwd) }
      let(:date) { Time.new(2020, 01, 01) }
      after(:example) { WebMock.reset! }

      it "should raise a 'get' ResponseError" do
        VCR.turned_off do
          WebMock.stub_request(:get,
                               "http://localhost:3000/games/1/answers/new").
            to_return(body: '<meta name="csrf-token" content="token" />',
                      headers: { "set-cookie" => 'cookie' },
                      status: 302)
          WebMock.stub_request(:any, "http://localhost:3000/users/sign_in").
            to_return(body: '<meta name="csrf-token" content="token" />',
                      headers: {"set-cookie" => 'cookie'})

          expect{ comm.create_answer(1, 1, "Q", "A", 100, date) }.
            to raise_error(ResponseError, /get response/)
        end
      end
    end

    context "post /games/1/answers fails" do
      let(:comm) { ImperilmentCommunicator.new(@uri, @user, @pwd) }
      let(:date) { Time.new(2020, 01, 01) }
      after(:example) { WebMock.reset! }

      it "should raise a 'post' ResponseError" do
        VCR.turned_off do
          WebMock.stub_request(:get,
                               "http://localhost:3000/games/1/answers/new").
            to_return(body: '<meta name="csrf-token" content="token" />',
                      headers: { "set-cookie" => 'cookie' },
                      status: 200)
          WebMock.stub_request(:any, "http://localhost:3000/users/sign_in").
            to_return(body: '<meta name="csrf-token" content="token" />',
                      headers: {"set-cookie" => 'cookie'})
          WebMock.stub_request(:post,
                               "http://localhost:3000/games/1/answers").
            to_return(body: '<meta name="csrf-token" content="token" />',
                      headers: {"set-cookie" => 'cookie', "location" => ["http://localhost:3000/games/1/answers"], },
                      status: 200)

          expect{ comm.create_answer(1, 1, "Q", "A", 100, date) }.
            to raise_error(ResponseError, /post response/)
        end
      end
    end

    context "#last_game_date", vcr: true do
      let(:comm) { ImperilmentCommunicator.new(@uri, @user, @pwd) }
      let(:date) { Time.new(2020, 01, 01) }
      after(:example) { WebMock.reset! }

      it "should raise a NoGamesError" do
        VCR.eject_cassette
        VCR.turned_off do
          WebMock.stub_request(:get, "http://localhost:3000/games.json").
            to_return(body: "[]", status: 200)
          WebMock.stub_request(:any, "http://localhost:3000/users/sign_in").
            to_return(body: '<meta name="csrf-token" content="token" />',
                      headers: {"set-cookie" => 'cookie'})

          expect{ comm.last_game_date }.to raise_error(NoGamesError)
        end
      end
    end
  end
end
