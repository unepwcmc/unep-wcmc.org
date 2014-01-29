# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if ContentType.count == 0
  [["Poster", "Posters"],
   ["Tool", "Tools / Applications"],
   ["Dataset", "Spatial Data / Maps"],
   ["Book", "Books"],
   ["Report", "Reports"],
   ["Journal Paper", "Journal Papers"],
   ["News", "News"]].each do |type|
    ContentType.create(singular: type[0], plural: type[1])
   end
end

if PositionType.count == 0
   ["Permanent",
    "Temporary",
    "part-time",
    "full-time" ].each do |position|
      PositionType.create(name: position)
    end
end

if User.count == 0
  user = User.new name: "user", email: "username@unep-wcmc.org", password: "password"
  user.skip_confirmation!
  user.save
end
