# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

QuoteStatus.create([
  { name: "Open", is_default: true, is_hidden: false },
  { name: "Ordered", is_default: false, is_hidden: false },
  { name: "Lost", is_default: false, is_hidden: false },
  { name: "Inactive", is_default: false, is_hidden: false }
  ])
