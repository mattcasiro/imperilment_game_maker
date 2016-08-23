require 'i_game_maker.rb'
require 'vcr_setup.rb'

describe IGameMaker do
  context "Creating a game" do
    VCR.use_cassette("new_game_cassette") do
      fail
    end
  end

  context "Creating a category" do
    VCR.use_cassette("new_game_cassette") do
      fail
    end
  end

  context "Creating an answer" do
    VCR.use_cassette("new_game_cassette") do
      fail
    end
  end
end
