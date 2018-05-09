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
    answer
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

  def guess(guess, answer)
  end

  def check_positions(guess, answer = @answer)
    positions = 0
    guess.length.times do |index|
      positions += 1 if guess[index] == answer[index]
    end
    positions
  end

  def check_elements(guess, answer)
  end

  def validate_guess(guess)
  end

  def invalid_feedback(invalid_guess)
  end
end
