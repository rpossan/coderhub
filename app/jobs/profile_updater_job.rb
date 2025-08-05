class ProfileUpdaterJob < ApplicationJob
  queue_as :default

  def perform(profiles_ids)
    profiles = Profile.where(id: profiles_ids)
    profiles.each do |profile|
      Rails.logger.info "Updating profile for #{profile.github_username}..."
      begin
        profile.update_github_data!
        Rails.logger.info "Profile updated successfully."
      rescue => e
        Rails.logger.error "Error updating profile for #{profile.github_username}: #{e.message}"
      end
    end
  end
end
