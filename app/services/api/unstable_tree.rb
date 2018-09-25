module Api
  class UnstableTree
    include HTTParty

    TREE_PATH = '/production/tree/'.freeze
    BASE_INTERVAL = 0 # The initial interval in seconds between tries.
    TRIES = 5 # Number of attempts to make at running your code block (includes initial attempt).
    VALID_RESPONSE_CODES = [200, 404].freeze

    base_uri 'https://kf6xwyykee.execute-api.us-east-1.amazonaws.com'

    def initialize(name)
      @path = "#{TREE_PATH}#{name}"
    end

    def call
      Retriable.retriable(base_interval: BASE_INTERVAL, tries: TRIES) do
        response = self.class.get(@path, format: :json)
        raise ExceptionHandler::UpstreamFailure unless VALID_RESPONSE_CODES.include?(response.code)
        response
      end
    end

    private

    attr_reader :path
  end
end
