class Profile < ApplicationRecord
  validates :github_url, presence: true, uniqueness: true, format: {
    with: /\A(https?:\/\/github\.com\/[a-zA-Z0-9\-_]+\/?|[a-zA-Z0-9\-_]+)\z/,
    message: "must be a valid GitHub URL or just the username"
  }

  validates :github_username, presence: true, uniqueness: true

  before_validation :extract_username
  before_validation :generate_github_url
  before_create :generate_short_url

  scope :search, ->(term) {
    where(
      "name LIKE ? OR github_username LIKE ? OR organization LIKE ? OR location LIKE ?",
      "%#{term}%", "%#{term}%", "%#{term}%", "%#{term}%"
    )
  }

  def update_github_data!
    scraped_profile = GithubService::Scrapper.new(github_username).profile
    self.name ||= scraped_profile.name
    self.avatar = scraped_profile.avatar
    self.github_username = scraped_profile.nickname
    self.github_url = GithubService::Scrapper::GITHUB_BASE_URL + scraped_profile.nickname
    self.followers = scraped_profile.followers
    self.following = scraped_profile.following
    self.stars = scraped_profile.stars
    self.contributions = scraped_profile.contributions
    self.organization = scraped_profile.organization
    self.location = scraped_profile.location
    save!
  end

  private

  def generate_github_url
    return if github_url.present?

    self.github_url = GithubService::Scrapper::GITHUB_BASE_URL + github_username.to_s
  end

  def extract_username
    return if github_url.blank?

    self.github_username = github_url.gsub(%r{\Ahttps?:\/\/github\.com\/}, "").gsub(/\/$/, "")
  end

  def generate_short_url
    self.short_url = UrlShortenerService.shorten_url(github_url) if github_url.present?
  end
end
