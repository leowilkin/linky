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

# Precompile assets here rather than at boot, so starting a container is just
# booting puma. SECRET_KEY_BASE_DUMMY lets the production environment load
# without the real secret; no database is reached during precompile.
ENV RAILS_ENV=production
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rake assets:precompile

# Expose port
EXPOSE 3000

# Start the server
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
