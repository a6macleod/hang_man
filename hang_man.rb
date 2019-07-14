# The total number of possible words is 61406

require 'yaml'

class HangMan
	attr_accessor :secret_word, :game_display, :alphabet, :guessed_letters, :guess_counter, :matched_word, :game_id
	
	def initialize
		@game_id = game_id_generator
		@secret_word = set_secret_word_list
		@game_display = set_guess_board(secret_word)
		@alphabet = ("a".."z").to_a
		@guessed_letters = []
		@guess_counter = 6
		@matched_word = false
	end

	def game_id_generator
		charset = Array('a'..'z') + Array(1..9)
		Array.new(3) { charset.sample }.join
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

	def compare_word_guess(player_word_guess)
		if player_word_guess == secret_word
			puts "You guessed correctly! You win!"
			self.matched_word = true
		end
	end

	def compare_letter_guess(player_guess)
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
		display_board
		out_of_guesses
	end

	def display_board
		puts "Guessed letters #{guessed_letters}"
		puts "You have #{guess_counter} guesses left"
		puts game_display.join('')
	end

	def out_of_guesses
		if guess_counter == 0
			puts "\n\n +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-\n\n"
			puts "You are out of guesses!"
			puts "the secret word was #{secret_word}\n\n"
		end
	end

	def save_game
		Dir.mkdir("saved_games") unless Dir.exists?("saved_games")

		filename = "saved_games/hangman_#{game_id}.yaml"
		
		save_file = File.open(filename, 'w')
		save_file.puts YAML.dump(self)
		save_file.close

		puts "Game saved as #{filename}"
	end
end

def list_saved_games
	puts "\nAll saved games"
	list_of_files = Dir["./saved_games/*.yaml"]
	list_of_files.each do |file|
		sub_string = file[file.index("h")..file.length]
		puts sub_string
	end
	pick_saved_game
end

def pick_saved_game
	puts "\n\nPick the game you want to load: "
	user_pick = gets.chomp.downcase
	file_to_load = "./saved_games/#{user_pick}"
	
	if File.exists?(file_to_load) == true
		return file_to_load
	else
		puts "\n\n\n*******************************"
		puts "Please enter a file that exists\n\n\n"
		list_saved_games
	end
end

def load_game
	saved_game_file = list_saved_games
	game_to_load = File.read(saved_game_file)
	current_game = YAML::load(game_to_load)
	play_game(current_game)
end

def play_game(current_game)
	puts "\n\n +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-\n\n"
	current_game.display_board
	until (current_game.matched_word == true) || (current_game.guess_counter == 0)
		puts "\n\nTo guess the word press 'W' and 'enter'. \nTo guess a letter presse 'enter'. \nTo 'SAVE' press 'S' and 'enter'" 
		letter_or_word = gets.chomp.downcase
		
		if letter_or_word == "w"
			puts "\n\n +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-\n\n"
			puts "Guess the word!"
			player_word_guess = gets.chomp.downcase.strip
			current_game.compare_word_guess(player_word_guess)
		elsif letter_or_word == "s"
			puts "\n\n +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-\n\n"
			current_game.save_game
		else
			puts "\n\n +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-\n\n"
			puts "Guess a letter"
			player_guess = gets.chomp.downcase
			
			if guess_validate(player_guess, current_game)
				current_game.compare_letter_guess(player_guess)
			else
				puts "Please enter one letter not yet picked then press 'enter'"
				play_game(current_game)
			end
		end
	end
	puts "\tGAME OVER"
	puts "\n\n +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-\n\n"
end

def guess_validate(player_guess, current_game)
	((current_game.alphabet - current_game.guessed_letters).include?player_guess) ? true : false
end

def start_new_game
	current_game = HangMan.new
	play_game(current_game)
end

def open_existing_or_start_new
	puts "Open an existing game? (y/n)"
	user_answer = gets.chomp.strip.downcase
	
	if user_answer == "y"
		load_game
		play_game(current_game)
	else 
		puts "\nNEW GAME!\n"
		start_new_game
	end
end

puts "\n\n +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-\n\n"
puts "Let's play Hang Man! Guess the secret word"
open_existing_or_start_new
