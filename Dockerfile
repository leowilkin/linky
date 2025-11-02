FROM ruby:3.3.2-slim

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    nodejs \
    npm \
    git \
    curl && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy Gemfile and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

# Copy the application
COPY . .

# Expose port
EXPOSE 3000

# Precompile assets and start the server
CMD ["bash", "-c", "bundle exec rake assets:precompile && bundle exec puma -C config/puma.rb"]
