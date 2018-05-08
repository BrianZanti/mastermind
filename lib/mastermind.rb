class Mastermind

  attr_reader :answer,
              :difficulty,
              :start_time,
              :num_guesses,
              :end_time

  def initialize(difficulty = :beginner)
  end

  def generate_answer(difficulty)
  end

  def guess(guess, answer)
  end

  def check_positions(guess, answer)
  end

  def check_elements(guess, answer)
  end

  def validate_guess(guess)
  end

  def invalid_feedback(invalid_guess)
  end
end
