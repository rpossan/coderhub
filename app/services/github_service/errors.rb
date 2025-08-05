module GithubService
  module Errors
    class Error < StandardError; end

    class UserDataNotFoundError < Error
      def initialize(msg = "User data not found")
      super
      end
    end
  end
end
