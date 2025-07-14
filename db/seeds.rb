# db/seeds.rb

require Rails.root.join('lib', 'build', 'database_builder').to_s

puts "Starting database seed process..."
Build::DatabaseBuilder.new.run
puts "Database seeding completed!"
