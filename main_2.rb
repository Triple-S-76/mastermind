# Starting the game
class MasterMind
  def initialize
    # @game = SetupGame.new
    # @game.game_type == 'maker' ? CodeMaker.new : CodeBreaker.new
    # CodeBreaker.new
    CodeMaker.new
  end
end

# Setting up the game
class SetupGame
  attr_accessor :game_type

  def initialize
    intro_and_rules
    game_type_question
    choice_made(@game_type)
    @game_type
  end

  private

  def empty_lines(number)
    number.times { puts }
  end

  def intro_and_rules
    empty_lines(1)
    puts 'This is a game of MasterMind'
    empty_lines(1)
    puts 'The object of the game is for the Code Maker to choose a 4 digit code using numbers 1 - 6 only.'
    empty_lines(1)
    puts 'Then the Code Breaker tries to break the code in under 12 tries.'
    empty_lines(1)
    puts 'After each guess, the code breaker is told how many correct numbers they have chosen.'
    puts 'and how many correct numbers they have choosen that are also in the correct position.'
    empty_lines(1)
  end

  def game_type_question
    puts 'Would you like to be the Code Maker or the Code Breaker?'
    empty_lines(1)
    puts 'Enter 1 for Code Maker.'
    empty_lines(1)
    puts 'Enter 2 for Code Breaker.'
    empty_lines(3)
    maker_or_breaker
  end

  def maker_or_breaker
    choice = gets.chomp
    @game_type = 'maker'   if choice.to_i == 1
    @game_type = 'breaker' if choice.to_i == 2
    not_valid(choice) unless %w[maker breaker].include?(game_type)
  end

  def not_valid(choice)
    3.times { puts }
    puts "Your selection of '#{choice}' is not a valid one."
    empty_lines(1)
    game_type_question
  end

  def choice_made(game_type)
    empty_lines(1)
    if game_type == 'maker'
      system 'clear'
      3.times { puts }
      puts 'Great choice, you are now the Code Maker!'
    else
      system 'clear'
      3.times { puts }
      puts 'Great choice, you are now the Code Breaker'
    end
    empty_lines(1)
  end
end

# Player is the Code Maker
class CodeMaker
  def initialize
    code = create_secret_code
    break_code_bruteforce(code)
  end

  private

  def break_code_bruteforce(code)
    round = 0
    broken = false
    until broken == true
      guess = ''
      round += 1
      4.times {guess << rand(1..6).to_s }
      broken = true if code == guess
    end
    puts "Your code of #{code} was broken in #{round} tries using bruteforce!"
  end

  def empty_lines(number)
    number.times { puts }
  end

  def create_secret_code
    valid = false
    until valid == true
      puts 'As the Code Maker you need to choose a 4 digit secret code using numbers 1 - 6 only!'
      puts 'Please make your selection now.'
      empty_lines(1)
      code = gets.chomp
      empty_lines(1)
      valid = validate_code(code)
    end
    code
  end

  def validate_code(code)
    return invalid_code(code) if code.length != 4

    code_array_integers = code.split('').map(&:to_i)
    code_array_integers.each do |num|
      return invalid_code(code) unless (1..6).include?(num)
    end

    true
  end

  def invalid_code(code)
    puts "#{code} is not a valid code."
    puts 'Please try again.'
    empty_lines(1)
    false
  end
end

# Player is the Code Breaker
class CodeBreaker
  def initialize
    new_code
    code_breaker_info
    @round = 1
    @winner = false
    game_loop
  end

  private

  def empty_lines(number)
    number.times { puts }
  end

  def new_code
    @code = []
    4.times { @code << rand(1..6) }
    p "#{@code} - @code"
  end

  def code_breaker_info
    empty_lines(1)
    puts 'OK, The computer has chosen a new secret code made up of 4 digits that are all 1 to 6'
    empty_lines(1)
    puts ''
  end

  def game_loop
    while @round <= 12 && @winner == false
      current_guess_string = player_guess(@round)
      current_guess_array_integers = current_guess_string.split('').map(&:to_i)
      valid_guess = check_for_invalid_guess(current_guess_string, current_guess_array_integers)
      redo if valid_guess == false
      @winner = compare_to_code(current_guess_array_integers)
    end
    game_ending
  end

  def game_ending
    empty_lines(5)
    if @winner == true
      puts 'You won the game!!'
    else
      p 'You are such a loser!!'
    end
    empty_lines(5)
  end

  def player_guess(number)
    puts "Please make your #{number}#{suffix(number)} guess!"
    empty_lines(1)
    gets.chomp
  end

  def check_for_invalid_guess(current_guess_string, current_guess_array_integers)
    return invalid_guess(current_guess_string) if current_guess_array_integers.length != 4

    current_guess_array_integers.each do |num|
      return invalid_guess(current_guess_string) unless (1..6).include?(num)
    end

    @round += 1
    true
  end

  def invalid_guess(current_guess_string)
    empty_lines(1)
    puts "Your guess of '#{current_guess_string}' is invalid. Please guess a 4 digit code using only numbers 1-6."
    empty_lines(1)
    false
  end

  def create_empty_hash
    hash = {}
    (1..6).each { |key| hash[key] = 0 }
    hash
  end

  def compare_to_code(current_guess_array_integers)
    computer_code_hash = create_computer_hash
    match_number = check_matching_numbers_only(current_guess_array_integers, computer_code_hash)

    match_number_and_location = check_matching_numbers_and_location(current_guess_array_integers)

    round_result_message(match_number, match_number_and_location)

    return true if match_number_and_location == 4

    false
  end

  def round_result_message(match_number, match_number_and_location)
    empty_lines(1)
    puts "You have matched #{match_number} numbers & there are #{match_number_and_location} in the correct position!"
    empty_lines(1)
  end

  def create_computer_hash
    hash = create_empty_hash
    @code.each { |num| hash[num] += 1}
    hash
  end

  def check_matching_numbers_only(current_guess_array_integers, computer_code_hash)
    match_number = 0
    current_guess_array_integers.each do |key|
      if computer_code_hash[key] != 0
        match_number += 1
        computer_code_hash[key] -= 1
      end
    end
    match_number
  end

  def check_matching_numbers_and_location(current_guess_array_integers)
    match = 0
    @code.each_with_index do |code_num, idx|
      match += 1 if code_num == current_guess_array_integers[idx]
    end
    match
  end

  def suffix(number)
    case number
    when 1
      'st'
    when 2
      'nd'
    when 3
      'rd'
    else
      'th'
    end
  end
end

MasterMind.new
