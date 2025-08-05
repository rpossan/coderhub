module GithubService
  class Contributions
    attr_reader :username, :url, :contributions
    def initialize(username)
      @username = username
      @url = URI("https://api.github.com/users/#{@username}/events/public")
      @contributions = 0
      fetch_contributions!
    end

    EVENTS = %w[PushEvent PullRequestEvent IssuesEvent IssueCommentEvent].freeze

    def fetch_contributions!
      one_year_ago = Date.today - 365
      @contributions = 0
      page = 1

      loop do
        uri = URI("#{@url}?page=#{page}")
        response = Net::HTTP.get_response(uri)

        raise Errors::UserDataNotFoundError if response.code != "200"

        events = JSON.parse(response.body)
        break if events.empty?

        events.each do |event|
          event_date = Date.parse(event["created_at"])
          break if event_date < one_year_ago

          @contributions += 1 if EVENTS.include?(event["type"])
        end

        page += 1
      end
    end
  end
end
