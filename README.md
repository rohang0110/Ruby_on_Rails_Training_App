# Ruby on Rails Training App

A simple Rails application for training and demonstration purposes.

## Setup Instructions

### Prerequisites

- Docker and Docker Compose
- OR Ruby 3.x, PostgreSQL, and Rails 7.x (for local setup)

### Docker Setup (Recommended)

1. Clone the repository
2. Start the application:

```bash
docker-compose up
```

3. In a separate terminal, set up the database:

```bash
docker-compose run web rails db:create
docker-compose run web rails db:migrate
```

### Local Installation (Alternative)

1. Clone the repository
2. Install dependencies:

```bash
bundle install
```

3. Database setup:

```bash
rails db:create
rails db:migrate
```

4. Start the Rails server:

```bash
rails server
```

### Fixing Database Errors

If you're seeing the error `PG::UndefinedTable: ERROR: relation "users" does not exist`, you need to run the database migrations:

```bash
# If using Docker:
docker-compose run web rails db:migrate

# If running locally:
rails db:migrate
```

If you continue to have database issues, you can use the reset script:

```bash
# Make the script executable
chmod +x bin/reset_db

# Run it
./bin/reset_db
```

## Features

- User authentication with Devise
- User registration with custom fields (name, phone, date of birth, etc.)
- Age validation based on date of birth

## Testing

Run the test suite with:

```bash
# With Docker
docker-compose run web rails test

# Locally
rails test
```

Or for system tests:

```bash
# With Docker
docker-compose run web rails test:system

# Locally
rails test:system
```
