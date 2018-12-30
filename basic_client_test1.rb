$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'bot'
# bot = Bot.new(:name =>ARGV[0], :data_file => ARGV[1])
bot = Bot.new(:name=>"Jack", :data_file =>"bot_data")
puts "#{bot.name} says:"+bot.greeting
user_lines.each do |line|
  puts "You asay:"+line
  puts "#{bot.name} says:"+bot.response_to(line)
end

# require 'bot'
# bot = Bot.new(:name =>ARGV[0], :data_file => ARGV[1])
#
# puts bot.greeting
# while input =gets and input.chomp !='goodbye'
#   puts ">>"+bot.respond_to?(input)
# end
# puts bot.farewell