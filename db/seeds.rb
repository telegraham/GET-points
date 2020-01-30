require 'faker'

if User.all.length == 0 
  20.times do
    user = User.create(name: Faker::Name.name)
    (1  ...100).to_a.sample.times do
      user.click!
    end
  end
end

puts "http://localhost:9393/login/#{ User.last.auth_token }"