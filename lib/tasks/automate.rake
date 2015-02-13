namespace :automate do
  desc "Run automated tests with capybara-webkit"
  task webkit: :environment do
    puts `rspec spec/**/*`
  end

  desc "Run automated tests with selenium"
  task selenium: :environment do
    puts `VISUAL=true rspec spec/**/*`
  end
end

task all: :webkit