require 'constants'
require 'active_support/core_ext/numeric/time'
require 'net/http'
require 'json'
require 'nokogiri'
require 'pry'

module GameSubmitter
  class ResponseError < StandardError
  end
  class NoGamesError < StandardError
  end

  class ImperilmentCommunicator
    # Imperliment Communicator for use with the API of an Imperilment
    # web server. Maintains a logged-in state through use of cookies.
    # 
    # @param user [String] is the username for an admin account
    # @param pwd [String] is the password for an admin account
    # @param uri [URI] is the URI for the imperilment server
    def initialize uri, user, pwd
      @uri = uri
      @user = user
      @pwd = pwd
    end

    # Create a new game on the Imperilment web server.
    #
    # @PRE: At least one previous game of Imperliment exists
    #       on the server, or a start date is provided
    #
    # @param ended_at [Date] the date the game ends on, defaults to
    #       seven days after the most recent game, required if no games exist
    # @returns [Int] the id of the game that was created
    def create_game ended_at=nil
      # Create game via Imperilment API
      result = Net::HTTP.start(uri.host, uri.port) do |http|
        ended_at = last_game_date + 7.days unless ended_at

        uri.path = '/games/new'
        result = get_request http
        raise ResponseError, "Invalid get response" if result.code.to_i != 200

        uri.path = '/games'
        form_data = {
          'authenticity_token': get_token(result.body),
          'game[ended_at]': ended_at,
          'commit': 'Create Game',
        }
        post_request http, form_data
      end
      raise ResponseError, "Invalid post response" if result.code.to_i != 302

      # Parse game id from HTTP result
      result.to_hash["location"][0][(uri.to_s.length + 1)..-1].to_i
    end

    # Create a new category on the Imperilment web server.
    #
    # @param name [String] is the name of the category to be created
    # @returns [int] the id of the category that was created
    def create_category name
      result = Net::HTTP.start(uri.host, uri.port) do |http|
        uri.path = '/categories/new'
        result = get_request http
        raise ResponseError, "Invalid get response" if result.code.to_i != 200

        uri.path = '/categories'
        form_data = {
          'authenticity_token': get_token(result.body),
          'category[name]': name,
          'commit': 'Create Category',
        }
        post_request http, form_data
      end
      raise ResponseError, "Invalid post response" if result.code.to_i != 302

      # Parse game id from HTTP result
      result.to_hash["location"][0][(uri.to_s.length + 1)..-1].to_i
    end

    # Create a new answer on the Imperilment web server.
    #
    # @param game_id [Int] is the game the answer belongs to
    # @param category_id [Int] is the category the answer belongs to
    # @param answer [String] is the answer the user will see
    # @param question [String] is the question the user should provide
    # @param value [Int] is the dollar value (nil for Final Jeopardy)
    # @returns [Int] the id for the answer that was created
    def create_answer game_id, category_id, question, answer, value, start_date
      result = Net::HTTP.start(uri.host, uri.port) do |http|
        uri.path = "/games/#{game_id}/answers/new"
        result = get_request http
        raise ResponseError, "Invalid get response" if result.code.to_i != 200

        uri.path = "/games/#{game_id}/answers"
        form_data = {
          'authenticity_token': get_token(result.body),
          'answer[category_id]': category_id,
          'answer[answer]': answer,
          'answer[correct_question]': question,
          'answer[amount]': value,
          'answer[start_date]': start_date
        }
        post_request http, form_data
      end
      raise ResponseError, "Invalid post response" if result.code.to_i != 302

      # Parse game id from HTTP result
      result.to_hash["location"][0][(uri.to_s.length + 1)..-1].to_i
    end

    # Get the end-date of the most recent game from the web server
    #
    # @returns [Date] the end_date of the most recent game
    # @raise [NoGamesError] if there are no games on the server
    def last_game_date
      Net::HTTP.start(uri.host, uri.port) do |http|
        uri.path = "/games.json"
        result = get_request http
        if JSON.parse(result.body).empty?
          raise NoGamesError, "No games exist on the server"
        end
        Date.strptime(JSON.parse(result.body).first['ended_at'])
      end
    end

    private
    attr_reader :user, :pwd, :uri
    def get_request http, log_in=false
      request = Net::HTTP::Get.new uri
      request['Cookie'] = cookie(http) unless log_in

      result = http.request request
      # Cookie maintains log-in state and auth token for CSRF protection
      @cookie = result['set-cookie']
      result
    end

    def post_request http, form_data
      request = Net::HTTP::Post.new uri
      request.set_form_data form_data
      request['Cookie'] = cookie(http)

      result = http.request request
      # Cookie maintains log-in state and auth token for CSRF protection
      @cookie = result['set-cookie']
      result
    end

    def get_token body
      Nokogiri.parse(body).xpath(TOKEN_REGEX)[0]['content']
    end

    def cookie http
      log_in_request(http) unless @cookie
      @cookie
    end

    def log_in_request http
      uri.path = '/users/sign_in'

      # Get form page token
      res = get_request http, true

      form_data = {
        'authenticity_token': get_token(res.body),
        'user[email]': user,
        'user[password]': pwd,
        'user[remember_me]': 1,
        'commit': 'Sign in',
      }
      post_request http, form_data
    end
  end
end
