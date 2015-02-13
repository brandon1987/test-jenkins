# README

Contribution guidelines are detailed in [CONTRIBUTING.md](https://github.com/jnoelcarney/cmonrails/blob/master/doc/CONTRIBUTING.md). I strongly encourage you to follow these.

The different respositories and servers are laid out in [ARCHITECTURE.md](https://github.com/jnoelcarney/cmonrails/blob/master/doc/ARCHITECTURE.md)

## Setup

Very importantly, you'll be missing a file called `config/secrets.yml`. This file contains... secrets. Stuff like database passwords that shouldn't be hard-coded into the repository. A skeleton copy of the file can be found at `doc/secrets.yml` in this repo.

## Dependencies

 * ruby 2.1.x
 * rails 4.1.x

## Compatibility

We're aiming to support IE9 and up. If you're unsure as to whether we can use a new and shiny HTML5/CSS3 feature, check out [caniuse.com](http://caniuse.com). This is also a good way of checking what browser prefixes are needed.

## Testing

Unit tests can be found in `test/`. These are done in minitest, and should aim to cover as much of the back end testing of controllers, models, etc. as possible. These can be executed with the command `rake test`.

`spec/` contains automation tests written with rspec and capybara. These should simulate user behaviour as closely as possible with click events etc. and can be executed with `rake automate:selenium` or `rake automate:webkit` depending on which engine you want to use.

Pushing code that causes tests to fail will be met with a disapproving gaze. 

## Monitoring

The application uses New Relic free tier for log and error monitoring. Give me (@jsrn) a shout if you want access to the pretty graphs.