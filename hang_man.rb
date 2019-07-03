# The total number of possible words is 61406
class HangMan
	attr_accessor :secret_word, :secret_word_list
	
	def initialize
		@secret_word = set_secret_word_list
	end

	def set_secret_word_list 
		word_array = []
		word_list_full = File.readlines "5desk.txt"

		word_list_full.each do |line|
			if line.size > 7 && line.size < 14
				word_array << line
			end
		end
		
		pick_secret_word(word_array)
	end

	def pick_secret_word(word_array)
		self.secret_word = word_array[rand(0..word_array.size)]
		return secret_word
	end
end

current_game = HangMan.new

puts "Guess the word!"

