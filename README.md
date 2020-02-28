# walrus.ai Web Crawler

Web crawling and caching.

This repository was generated from a template or is the template itself.  For more information, see [docs/TEMPLATE.md](./docs/TEMPLATE.md).

## Setup

To install dependencies:

```bash
bundle exec bundle install
yarn install
```

To setup the database, ensure that an instance of PostgreSQL is running locally, and run:

```bash
bundle exec rake db:setup
```

## Develop

To run the Rails web server and Webpack development server via Foreman:

```bash
bundle exec foreman start
```

## Test

To test the platform:

```bash
bundle exec rake test
```

To automatically run tests when files are saved:

```
bundle exec guard
```

When tests are run manually, a code coverage report is generated at `coverage/index.html`.
