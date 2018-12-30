$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'wordplay'
require 'yaml'
#A basic implementation of a chatterbot
class Bot
  attr_reader :name
  def initialize(options)
    @name = options[:name] || "Unnamed Bot"
    begin
      @data = YAML.load(File.open(options[:data_file]).read)
    rescue
      raise "Can't load bot data"
    end
  end

  def greeting
   random_response (:greeting)
  end
  def farewell
   random_response (:farewell)
  end
  def response_to(input)
    prepared_input = preprocess(input.downcase)
    sentence = best_sentence(prepared_input)
    reversed_sentence = WordPlay.switch_pronouns(sentence)
    responces = possible_responces(sentence)
    responces[rand(responces.length)]
  end
  private
  def random_response(key)
    rand_index = rand(@data[:responses][key].length)
    @data[:responses][key][rand_index].gsub(/\[name \]/,@name)
  end

  def preprocess(input)
    perform_substitutions(input)
  end

  def perform_substitutions(input)
    @data[:presubs].each{ |s| input.gsub!(s [0], s [1])}
    input
  end

  def best_sentence(input)
    hot_words = @data[:responses].keys.select do |k|
      k.class == String  && k=~/^\w+$/
    end
    WordPlay.best_sentence(input.sentences, hot_words)
  end

  def possible_responces(sentence)
    responses = []
    #find all patterns to try to match against
    @data[:responses].keys.each do |pattern|
      next unless pattern.is_a?(String)

      #for each pattern, see if the supplied sentence contains
      # a match.Remove substitution sysbols (*) before checking
      # push all responses to the responses array
      if sentence.match('\b'+pattern.gsub(/\*/,' ')+'\b')
          #if the pattern contains substitution placeholders
          # perform the substitutions
          if(pattern.include?('*'))
            responses << @data[:responses][pattern].collect do |phrase|
              #first, erase everything before the placeholder
              # leaving everything after it
              matching_section = sentence.sub(/^.*#{pattern}\s+/,' ')

              #then substitute the text after the placeholder,with
              # the pronouns switched
              phrase.sub('*', WordPlay.switch_pronouns(matching_section))
            end
          else
            #No placeholder ? Just add the phrases to the array
            responses <<@data[:responses][pattern]
          end
      end
    end
    #if there were no matches, add the default ones
    responses <<@data[:responses][:default] if responses.empty?
    #flattern the blocks of responses to a  flat array
    responses.flatten
  end
end