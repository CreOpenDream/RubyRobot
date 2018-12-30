$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'bot'
# bot = Bot.new(:name =>ARGV[0], :data_file => ARGV[1])
bot = Bot.new(:name=>"Jack", :data_file =>"bot_data")
user_lines = File.readlines(ARGV[2],'r')

puts bot.greeting
while input =$stdin.gets and input.chomp != 'end'
  puts '>>'+bot.response_to(input)
end
puts bot.farewell
# require 'bot'
# bot = Bot.new(:name =>ARGV[0], :data_file => ARGV[1])
#
# puts bot.greeting
# while input =gets and input.chomp !='goodbye'
#   puts ">>"+bot.respond_to?(input)
# end
# puts bot.farewell