# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "#{Rails.root}/log/cron.log"
#
every :week do
  # command "/usr/bin/some_great_command"
  # runner "MyModel.some_method"
  rake "profiles:update_github_info"
end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
