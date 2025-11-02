Linky
---

Linky is your friendly internal URL shortener service.

This app is super simple to get up and running and makes managing intranet short links super simple!

# What's different on this fork?

leowilkin/linky is a fork of [parabuzzle/linky](https://github.com/parabuzzle/linky). This fork adds support for SSO (I'm using Authentik) through OmniAuth, multiple custom domain names, and private SSO-required links.

Instead of an intranet app, this fork is designed to be used as a general purpose URL shortener for any organization or person!

# Why Linky?

While I was searching for an open source version of the kinds of intranet URL shorteners that I was used to using at companies around Silicon Valley, I found that there are a ton of URL shorteners out there but all of them are either over complicated or just a "proof of concept". Linky was built to serve as a simple, yet useful, URL shortener for use internally in company based on what I've observed as useful inside large organizations.

![/dashboard.jpg](/dashboard.jpg)

![/param_passing.jpg](/param_passing.jpg)

# Installation

## Requirements

You will need a postgres database to connect to.

## Docker / Coolify

### Using Docker Compose:

```bash
# Copy the example env file
cp .env.production.example .env

# Edit .env with your values
nano .env

# Generate a secret key base
docker run --rm ruby:3.4.7 ruby -e "require 'securerandom'; puts SecureRandom.hex(64)"

# Start the application
docker-compose up -d
```

### Required Environment Variables

  * `SECRET_KEY_BASE` - Rails secret key (generate with `rake secret`)
  * `AUTHENTIK_URL` - Your Authentik instance URL
  * `AUTHENTIK_CLIENT_ID` - OAuth client ID from Authentik
  * `AUTHENTIK_CLIENT_SECRET` - OAuth client secret from Authentik
  * `ADMIN_EMAILS` - Comma-separated list of admin email addresses
  * `ALLOWED_HOSTS` - Comma-separated list of allowed domains (for production)
  * `DB_PASS` - Database password (optional, defaults to 'linky')

### Optional Environment Variables

  * `SENTRY_DSN` - Sentry error tracking DSN (for production monitoring)
  * `SENTRY_TRACES_SAMPLE_RATE` - Percentage of transactions to track (default: 0.1)

### Coolify Deployment

1. Create a new service in Coolify
2. Point to your Git repository
3. Set the required environment variables in Coolify
4. Deploy!

The app will be available on port 3000.

## Setup the Database

You need to create and setup the database on the first run:

```
rake db:create; rake db:migrate
```

or docker:

```
docker run -e DB=your_database -e DB_USER=your_user -e DB_PASS=your_pass parabuzzle/linky rake db:create; rake db:migrate
```

# Features

## Multi-Domain Support

Linky supports scoping short links to specific domains, allowing you to serve different links based on the domain being accessed. You can configure allowed domains via the Settings page (`/settings`) without touching code.

- **Domain-scoped links**: Create links that only work on specific domains
- **Global links**: Leave the domain field blank to create links that work on all domains
- **Priority**: Domain-specific links take priority over global ones

## Quick Link Creation

Two convenient ways to create short links on the fly:

### Auto-Generate Random Short Link

Simply prepend your configured domain to any URL to instantly create a random 6-character short link:

```
go.wilkin.xyz/https://google.com
→ Creates and redirects to: go.wilkin.xyz/a3k9d2
```

Works with any URL format:
- Full URLs: `go.wilkin.xyz/https://github.com/user/repo`
- Domain only: `go.wilkin.xyz/example.com`

### Manual Creation Form

Prefix any URL with `/s/` to open the link creation form with the URL pre-filled:

```
go.wilkin.xyz/s/https://google.com
→ Opens form with URL already filled in
```

This lets you customize the short name, add param passing, set domain scope, or require authentication before saving.

## Params Passing

Params passing allows you to create fancier URL's by allowing you to specify a special redirect url when something is given after the initial short url.

As an example, let's say we have a short url known as `twsearch` that points to `http://www.twitter.com/search`... ok but then I've got to input my search when I get to the page... what if I could do `http://go/twsearch/mysearch` and it just executed the search? Well with params parsing you can! If I put `http://www.twitter.com/search?q=` in the optional params parsing field for the short url, it will split the `twsearch/mysearch` and pass the `mysearch` at the end of the url which would send you to `http://www.twitter.com/search?q=mysearch` automatically!

This feature is really useful for things like jira where you have a project like `myproject` linked with `myjira` which would send you to the dashboard but if you wanted to go directly to a ticket, you could do `/myjira/TKT-123` which would use the ticket url. The possiblities are endless here!
