module GithubService
  class Scrapper
    include HTTParty

    attr_reader :username, :profile

    def initialize(username)
      @username = username
      fetch_profile!
    end

    GITHUB_BASE_URL = "https://github.com/".freeze

    def fetch_profile!
      return {} unless @username

      response = HTTParty.get("#{GITHUB_BASE_URL}#{@username}", {
        headers: {
          "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
        },
        timeout: 10
      })

      return parse_data(response.body) if response.success?

      raise Errors::UserDataNotFoundError
    end

    private

    def parse_data(html)
      doc = Nokogiri::HTML html
      map = Map.new
      @profile = ParsedProfile.new
      @profile.name = doc.css(map.name).first.text.strip
      @profile.nickname = doc.css(map.nickname).first.text.strip
      @profile.followers = parse_count(doc.css(map.followers).first.text.strip)
      @profile.following = parse_count(doc.css(map.following).first.text.strip)
      @profile.stars = parse_count(doc.css(map.stars).first.text.strip)
      @profile.contributions = Contributions.new(@username).contributions
      @profile.avatar = doc.css(map.avatar).first["src"]
      @profile.organization = doc.css(map.organization).first&.text&.strip
      @profile.location = doc.css(map.location).first&.text&.strip
    end

    def parse_count(text)
      return 0 if text.blank?

      normalized = text.strip.downcase
      case normalized
      when /k$/
      (normalized.delete("k").to_f * 1_000).to_i
      when /m$/
      (normalized.delete("m").to_f * 1_000_000).to_i
      else
      normalized.gsub(/[^\d]/, "").to_i
      end
    end
  end
end
