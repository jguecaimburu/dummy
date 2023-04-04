# README

## Running the application

### Dependencies:
- Ruby 3.1.3
- PostgreSQL 15.2
- Yarn 1.22
- Redis 7.0.10

### Installation
- Install dependencies
- Clone this repo
- Run `bundle` and `yarn install`
- Create the db with `bin/rails db:prepare`

### Run
- Initialize PostgreSQL and Redis
- Run Sidekiq with `bundle exec sidekiq`
- Run the app and bundle assets with `bin/rails dev`

To populate the application with data from the Dummy Json api, run in a Rails console: `FetchDummyJsonUsersJob.perform_async`

## Formatting and testing

This project uses [Rubocop](https://github.com/rubocop/rubocop) to format Ruby code. You can check and try to fix styles by running `bundle exec rubocop -A`.

Test suite built with [Rspec](https://github.com/rspec/rspec-rails). Run the full test with:
```sh
bundle exec rspec
```
