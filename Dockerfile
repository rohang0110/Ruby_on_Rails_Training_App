FROM ruby:3.2

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Set working directory
WORKDIR /Ruby_on_Rails_Training_App

# Install bundler
RUN gem install bundler

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the app
COPY . .

# Expose port
EXPOSE 3000

# Start server with file watching
CMD ["bin/rails", "server", "-b", "0.0.0.0"]