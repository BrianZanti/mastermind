require 'minitest/autorun'
require 'minitest/pride'
require './lib/mastermind'
require 'pry'

class MastermindTest < Minitest::Test
  def setup
    @mastermind = Mastermind.new
  end

  def test_it_exists
    assert_instance_of Mastermind, @mastermind
  end

  def test_attributes
    assert_equal :intermediate, Mastermind.new(:intermediate).difficulty
    assert_equal :beginner, @mastermind.difficulty
    assert_instance_of Time, @mastermind.start_time
    assert @mastermind.start_time < Time.now
    assert_instance_of String, @mastermind.answer
    assert_equal 4, @mastermind.answer.length
    assert_equal 0, @mastermind.num_guesses
    assert_nil @mastermind.end_time
  end

  def test_possible_colors
    assert_equal "rgby", @mastermind.possible_colors
    assert_equal "rgbyv", Mastermind.new(:intermediate).possible_colors
    assert_equal "rgbyvo", Mastermind.new(:advanced).possible_colors
  end

  def test_answer_length
    assert_equal 4, @mastermind.answer_length
    assert_equal 6, Mastermind.new(:intermediate).answer_length
    assert_equal 8, Mastermind.new(:advanced).answer_length
  end

  def test_generate_beginner_answer
    answer = @mastermind.generate_answer
    assert_instance_of String, answer
    assert_equal 4, answer.length
    possible_colors = ["r", "g", "b", "y"]
    answer.chars.each do |color|
      assert possible_colors.include? color
    end
  end

  def test_generate_intermediate_answer
    @mastermind = Mastermind.new(:intermediate)
    answer = @mastermind.generate_answer
    assert_instance_of String, answer
    assert_equal 6, answer.length
    possible_colors = ["r", "g", "b", "y", "v"]
    answer.chars.each do |color|
      assert possible_colors.include? color
    end
  end

  def test_generate_advanced_answer
    @mastermind = Mastermind.new(:advanced)
    answer = @mastermind.generate_answer
    assert_instance_of String, answer
    assert_equal 8, answer.length
    possible_colors = ["r", "g", "b", "y", "v", "o"]
    answer.chars.each do |color|
      assert possible_colors.include? color
    end
  end

  def test_check_positions
    assert_equal 2, @mastermind.check_positions("rbbg", "bbrg")
    assert_equal 0, @mastermind.check_positions("rgbb", "bbrg")
    assert_equal 4, @mastermind.check_positions("bbrg", "bbrg")
  end

  def test_check_elements
    assert_equal 4, @mastermind.check_elements("rbbg", "bbrg")
    assert_equal 3, @mastermind.check_elements("ggrb", "bbrg")
    assert_equal 0, @mastermind.check_elements("yyyy", "bbrg")
  end

  def test_validate_guess
    skip
    assert @mastermind.validate_guess("rgby")
    refute @mastermind.validate_guess("rgbyr")
    refute @mastermind.validate_guess("rgb")
    refute @mastermind.validate_guess("rxby")
    refute @mastermind.validate_guess("r gby")
    refute @mastermind.validate_guess("r by")
  end

  def test_invalid_feedback
    skip
    assert_equal "is too long", @mastermind.validate_guess("rgbyr")
    assert_equal "is too short", @mastermind.validate_guess("rgb")
    assert_equal "contains invalid characters", @mastermind.validate_guess("rxby")
    assert_equal "is too long", @mastermind.validate_guess("r gby")
    assert_equal "contains invalid characters", @mastermind.validate_guess("r by")
  end

  def test_guess
    skip
    expected = {elements: 4, positions: 2}
    assert_equal expected, @mastermind.guess("rbbg", "bbrg")
    assert_equal 1, @mastermind.num_guesses
    expected = {elements: 4, positions: 1}
    assert_equal expected, @mastermind.guess("rgbb", "bbrg")
    expected = {elements: 3, positions: 0}
    assert_equal expected, @mastermind.guess("ggrb", "bbrg")
    assert_equal 3, @mastermind.num_guesses
  end

  def test_win_output
    skip
    answer = @mastermind.answer
    guess = answer[0..2]
    if answer[3] != "r"
      guess += "r"
    else
      guess += "g"
    end
    @mastermind.guess(guess, answer)
    @mastermind.guess(guess, answer)
    @mastermind.guess(answer, answer)
    start = "Congratulations! You guessed the sequence #{answer} in 3 guesses over "
    output = @mastermind.win_output
    assert output.start_with? start
    output = @mastermind.win_output.split
    assert_instance_of Integer, output[10].to_i
    assert_equal "minutes,", output[11]
    assert_instance_of Integer, output[12].to_i
    assert_equal "seconds.", output[13]
  end
end
