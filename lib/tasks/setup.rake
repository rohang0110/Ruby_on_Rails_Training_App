namespace :setup do
  desc "Setup the application: install dependencies, create and migrate database"
  task all: :environment do
    puts "Setting up the Rails application..."

    # Database setup
    puts "\nSetting up the database..."
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    puts "Database setup complete."

    puts "\nApplication setup complete! Run 'rails server' to start the application."
  end

  desc "Reset the application: drop database, recreate and migrate"
  task reset: :environment do
    puts "Resetting the application..."

    # Database reset
    puts "\nResetting the database..."
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    puts "Database reset complete."

    puts "\nApplication reset complete!"
  end
end

desc "Quick setup for the application"
task setup: "setup:all"

desc "Reset the application"
task reset: "setup:reset"
