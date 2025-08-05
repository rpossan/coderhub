require "yaml"

module GithubService
  class Map
    CONFIG_PATH = File.join(__dir__, "../../../config/github_map.yml")

    attr_reader :elements, :name, :nickname, :followers, :following, :stars, :contributions, :avatar, :location, :organization

    def initialize
      @elements = load_config
      @profile = @elements["profile"]
      @name = @profile["name"]
      @nickname = @profile["nickname"]
      @followers = @profile["followers"]
      @following = @profile["following"]
      @stars = @profile["stars"]
      @contributions = @profile["contributions"]
      @avatar = @profile["avatar"]
      @location = @profile["location"]
      @organization = @profile["organization"]
    end

    private

    def load_config
      YAML.load_file(CONFIG_PATH)
    rescue Errno::ENOENT
      raise "Github map elements configuration file not found: #{CONFIG_PATH}"
    end
  end
end
