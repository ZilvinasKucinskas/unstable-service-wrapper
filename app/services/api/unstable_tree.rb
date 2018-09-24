module Api
  class UnstableTree
    include HTTParty

    TREE_PATH = '/production/tree/'.freeze

    base_uri 'https://kf6xwyykee.execute-api.us-east-1.amazonaws.com'

    def initialize(name)
      @path = "#{TREE_PATH}#{name}"
    end

    def call
      self.class.get(@path, format: :json)
    end

    private

    attr_reader :path
  end
end
