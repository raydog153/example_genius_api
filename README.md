# README

This README document steps to get the application up and running and tested.

## Local Development Setup
* Prerequisites:
    * Ruby 3.1.2
    * yarn, can install with command `brew install yarn`
    * Env config file named `.env` in root dir, and populate this file with `GENIUS_API_ACCESS_TOKEN: {valid API access token}`
* Checkout repo
* Install gem dependencies: `bundle install`
* Install js dependencies: `./bin/rails javascript:install:esbuild`

## How to run app
* Start server: `./bin/dev`
* View UI in browser: `http://127.0.0.1:3000/`

## How to run unit tests
* Run `rake -t`
* View coverage in browser: `open coverage/index.html`
