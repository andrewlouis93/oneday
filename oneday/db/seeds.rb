# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



yourUser = User.new(email: "andrew.louis93@gmail.com", password: "fawkes.1234", )
14.downto(0) do |i|
  todo = Todo.new(done:true,user: "andrew.louis93@gmail.com",name:"GUCCIGUCCI")
  todo.updated_at = Time.now.advance({days: - i})
  todo.save!
end