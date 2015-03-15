# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Item.create([
  {
    title: 'Item 1',
    content: 'Item 1 swoops in for the win'
  },
  {
    title: 'Item 2',
    content: 'Item 2 has no idea what he is doing'
  },
  {
    title: 'Item 3',
    content: 'Item 3 is a list of wholesome goodness',
    children_attributes: [
      {
        title: 'Item 3.1',
        content: 'I am a child'
      }
    ]
  }
])
