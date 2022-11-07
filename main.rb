
class Mastermind

  @pc_code = []

  def initialize
    
    maker_or_breaker = 0
    until (maker_or_breaker == 1 || maker_or_breaker == 2)
      puts "Would you like to be the code maker or the code breaker?"
      puts "Press 1 to be the code maker"
      puts "Press 2 to be the code breaker"
      maker_or_breaker = gets.chomp.to_i
      if maker_or_breaker == 1
        puts "You chose to be the code maker."
      elsif maker_or_breaker == 2
        puts "You chose to be the code breaker."
        pc_code = ComputerMaker.new
        player_guesses_code(pc_code.code)
      else
        puts "\nYou must choose 1 or 2 to play\n\n"
      end
    end
    
  end

  private
  
  class ComputerMaker
    attr_reader :code
    def initialize
      puts "The PC has chosen a secret code."
      @code = []
      4.times do
        @code << rand(1...6)
      end
      @code
    end
  end

  def player_guesses_code(pc_code)
    guesses = 12
    until (guesses == 0)
      puts "You have #{guesses} guesses left. Guess the code:"
      player_guess = gets.chomp
      if valid_guess(player_guess) == false
        puts "You need to enter 4 digits with each 1 being between 1 and 6."
        next
      end
      check_guess(pc_code, player_guess)
      guesses -= 1
      if guesses == 0
        puts "Better luck next time."
      end
    end
  end

  def valid_guess(player_guess)
    array = player_guess.to_s.split("")
    return false if array.length != 4
    array.each do |number|
      valid_number = (1..6) === number.to_i ? true : false
      return false if valid_number == false
    end
  end

  def check_guess(pc_code, player_guess)
    player_array = player_guess.split("")
    player_array = player_array.map! {|number| number.to_i}
    total_correct = 0
    partial_correct = 0
    
    # check for correct number in the correct position
    player_array.each_with_index do |player_number, player_index|
      total_correct += 1 if player_number == pc_code[player_index]
      if total_correct == 4
        puts "You cracked the code!"
        exit
      end
    end

    # check for correct number anywhere in the pc_code

    temp_pc_code = []
    pc_code.each {|number| temp_pc_code << number}
    player_array.each do |player_number|
      if temp_pc_code.include?(player_number)
        index = temp_pc_code.find_index(player_number)
        temp_pc_code[index] = 0
        partial_correct += 1
      end
    end
    
    p total_correct.to_s + " are the correct number(s) and they are in the correct position"
    partial_correct = partial_correct - total_correct
    p partial_correct.to_s + " are the correct number(s) but in the wrong position"

  end

end

Mastermind.new
