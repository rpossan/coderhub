namespace :profiles do
  desc "Update GitHub profile information"
  task :update_github_info, [ :username, :token ] => :environment do |t, args|
    username = args[:username] || ENV["GITHUB_USERNAME"]
    if username.nil?
      profiles = Profile.all
    else
      profiles = Profile.where(github_username: github_)
    end

    ProfileUpdaterJob.perform_later(profiles.pluck(:id))
  end
end
