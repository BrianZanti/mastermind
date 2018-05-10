require './lib/mastermind'

class UserInterface
  def start
    print "Welcome to MASTERMIND"
    loop do
      if main_menu
        play
      else
        break
      end
    end
  end

  def main_menu
    loop do
      print main_menu_prompt
      input = gets.chomp.downcase
      if input == 'p' || input == 'play'
        return true
      elsif input == 'i' || input == 'instructions'
        puts instructions
      elsif input == 'q' || input == 'quit'
        return false
      else
        puts invalid_text
      end
    end
  end

  def play
    difficulty = get_difficulty
    mastermind = Mastermind.new(difficulty)
    puts start_game_text(mastermind)
    loop do
      print "What is your guess? > "
      guess = gets.chomp.downcase
      if guess == "q" || guess == "quit"
        break
      elsif guess == "c" || guess == "cheat"
        puts "The correct answer is " + mastermind.answer
      elsif mastermind.validate_guess(guess)
        correct = take_guess(guess, mastermind)
        break if correct
      else
        puts "Your guess " + mastermind.invalid_feedback(guess)
      end
    end
  end

  def take_guess(guess, mastermind)
    feedback = mastermind.guess(guess)
    if(mastermind.answer == guess)
      puts mastermind.win_output
      return true
    else
      puts format_feedback(guess, feedback)
      return false
    end
  end

  def get_difficulty
    loop do
      print difficulty_prompt
      input = gets.chomp.downcase
      if input == "b" || input == "beginner"
        return :beginner
      elsif input == "i" || input == "intermediate"
        return :intermediate
      elsif input == "a" || input == "advanced"
        return :advanced
      else
        puts invalid_text
      end
    end
  end

  def format_feedback(guess, feedback)
    "Your guess #{guess} has #{feedback[:elements]} correct elements "\
    "in #{feedback[:positions]} correct positions"
  end

  def start_game_text(mastermind)
    num_elements = {
      beginner: "four",
      intermediate: "six",
      advanced: "eight"
    }
    color_names = {
      'r' =>  '(r)ed',
      'g' =>  '(g)reen',
      'b' =>  '(b)lue',
      'y' =>  '(y)ellow',
      'v' =>  '(v)iolet',
      'o' =>  '(o)range',
    }
    colors = mastermind.possible_colors.chars.map do |color|
      color_names[color]
    end
    colors = colors.join(", ").split.insert(-2, "and").join(" ")
    return "I have generated a #{mastermind.difficulty.to_s} sequence with #{num_elements[mastermind.difficulty]} "\
            "elements made up of: #{colors}. Use (q)uit at any time to end the game."
  end

  def main_menu_prompt
    "Would you like to (p)lay, read the (i)nstructions, or (q)uit?\n> "
  end

  def invalid_text
    "Sorry, I didn't understand you.\n\n"
  end

  def instructions
    "I will generate a random sequence of colors for you to guess. "\
    "When you make a guess, I will tell you how many colors you "\
    "have right, and how many of those are in the right position."
  end

  def difficulty_prompt
    "What difficulty would you like to play?\n"\
    "(b)eginner - 4 colors, 4 positions\n"\
    "(i)intermediate - 5 colors, 6 positions\n"\
    "(a)dvanced - 6 colors, 8 positions\n"\
    "> "
  end
end
