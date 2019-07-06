# The total number of possible words is 61406
class HangMan
	attr_accessor :secret_word, :game_display, :alphabet, :guessed_letters, :guess_counter, :matched_word
	
	def initialize
		@secret_word = set_secret_word_list
		@game_display = set_guess_board(secret_word)
		@alphabet = ("a".."z").to_a
		@guessed_letters = []
		@guess_counter = 6
		@matched_word = ""
	end

	def set_secret_word_list 
		word_array = []
		word_list_full = File.readlines "5desk.txt"

		word_array = word_list_full.select do |line|
			line.strip!.downcase!
			line.size > 5 && line.size < 12
		end
		pick_secret_word(word_array)
	end

	def pick_secret_word(word_array)
		self.secret_word = word_array[rand(0..word_array.size)]
		puts secret_word
		return secret_word
	end

	def set_guess_board(secret_word)
		temporary_array = []
		secret_word.size.times do 
			temporary_array << " _ "
		end
		self.game_display = temporary_array
		return game_display
	end

	def compare_guess(player_guess)
		if secret_word.include?player_guess
			matched_letter = []
			secret_word_array = secret_word.split('')

			secret_word_array.each_with_index do |letter, index|
				if player_guess == letter
					self.game_display[index] = player_guess
				end
			end
		end
		turn_end(player_guess)
	end

	def turn_end(player_guess)
		self.guessed_letters << player_guess
		self.guess_counter -= 1
		puts "Guessed letters #{guessed_letters}"
		puts "You have #{guess_counter} guesses left"
		display_board
	end

	def display_board
		puts game_display.join('')
	end
end

def play_game(current_game)
	puts "Guess a letter"
	puts current_game.display_board
	until (current_game.matched_word.size == current_game.secret_word.size) || (current_game.guess_counter == 0)
		#puts "To guess the word press ('W') or just enter to guess a letter" 
			#letter_or_word = gets.chomp.downcase
			#if letter_or_word == "w"
				#code for guessing the word
			#else
				player_guess = gets.chomp.downcase
				if guess_validate(player_guess, current_game)
					puts current_game.game_display
					current_game.compare_guess(player_guess)
				else
					puts "Please enter one letter not yet picked then press 'enter'"
					play_game(current_game)
				end
	end
	puts "\tGAME OVER"
end

def guess_validate(player_guess, current_game)
	((current_game.alphabet - current_game.guessed_letters).include?player_guess) ? true : false
end

def start_game
	current_game = HangMan.new
	play_game(current_game)
end

puts "Guess the word!"
start_game

