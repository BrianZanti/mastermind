class Mastermind

  attr_reader :answer,
              :difficulty,
              :start_time,
              :num_guesses,
              :end_time

  def initialize(difficulty = :beginner)
    @difficulty = difficulty
    @start_time = Time.now
    @num_guesses = 0
    @answer = generate_answer
  end

  def generate_answer
    colors = possible_colors.chars
    length = answer_length
    answer = ""
    length.times do
      answer << colors.sample
    end
    return answer
  end

  def possible_colors
    return 'rgby' if @difficulty == :beginner
    return 'rgbyv' if @difficulty == :intermediate
    return 'rgbyvo' if @difficulty == :advanced
  end

  def answer_length
    return 4 if @difficulty == :beginner
    return 6 if @difficulty == :intermediate
    return 8 if @difficulty == :advanced
  end

  def guess(guess, answer = @answer)
    positions = check_positions(guess, answer)
    elements = check_elements(guess, answer)
    @num_guesses += 1
    return {elements: elements, positions: positions}
  end

  def check_positions(guess, answer)
    positions = 0
    guess.length.times do |index|
      positions += 1 if guess[index] == answer[index]
    end
    return positions
  end

  def check_elements(guess, answer)
    elements = 0
    answer_copy = answer.dup
    guess.chars.each do |guess_color|
      answer_copy.chars.each.with_index do |answer_color, index|
        if guess_color == answer_color
          elements += 1
          answer_copy[index] = "x"
          break
        end
      end
    end
    return elements
  end

  def validate_guess(guess)
    return false if guess.length != answer_length
    guess.chars.each do |char|
      return false unless possible_colors.include? char
    end
    return true
  end

  def invalid_feedback(invalid_guess)
    if invalid_guess.length > answer_length
      return "is too long"
    elsif invalid_guess.length < answer_length
      return "is too short"
    else
      return "contains invalid characters"
    end
  end

  def win_output
    elapsed_seconds = (Time.now - @start_time).to_i
    minutes = elapsed_seconds / 60
    seconds = elapsed_seconds % 60
    return "Congratulations! You guessed the sequence #{@answer} "\
           "in #{@num_guesses} guesses over #{minutes} minutes, #{seconds} seconds."
  end

end
