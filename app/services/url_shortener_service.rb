class UrlShortenerService
  def self.shorten_url(original_url)
    generate_unique_code original_url
  end

  def self.expand_url(short_code)
    profile = Profile.find_by_short_url(short_code)
    return nil unless profile

    "#{ENV['APP_URL']}/profiles/#{profile.id}"
  end

  private

  def self.generate_unique_code(url)
    base_code = Digest::MD5.hexdigest(url)[0, 8]
    code = base_code
    suffix = 1

    while Profile.exists?(short_url: code)
      code = "#{base_code[0, 6]}#{suffix}"
      suffix += 1
    end

    code
  end
end
