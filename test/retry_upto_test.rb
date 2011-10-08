require './test/test_helper'

class Retry_uptoTest < MiniTest::Unit::TestCase

  class FooError < Exception; end
  class BarError < Exception; end

  class Target
    attr_accessor :foos, :bars
    def initialize
      @foos = 0
      @bars = 0
    end

    # raises FooError only in the two first calls
    def foo!
      @foos += 1
      raise FooError if @foos < 3
    end

    # raises BarError only in the two first calls
    def bar!
      @bars += 1
      raise BarError if @bars < 3
    end
  end

  def setup
    @target = Target.new
  end

  # number of attempts

  def test_retries_one_time_by_default_without_capturing_the_exception
    assert_raises(FooError) do
      retry_upto{ @target.foo! }
    end
    assert_equal 1, @target.foos
  end

  def test_retries_the_desired_number_of_attempts
    retry_upto(3){ @target.foo! }
    assert_equal 3, @target.foos
  end

  # interval between attempts

  def test_there_is_no_interval_between_attempts_by_default
    self.expects(:sleep).times(2).with(0).returns(nil)
    retry_upto(3){ @target.foo! }
  end

  def test_interval_between_attempts_can_be_customized
    self.expects(:sleep).times(2).with(5).returns(nil)
    retry_upto(3, :interval => 5){ @target.foo! }
  end

  # interval growth between attempts

  def test_inverval_can_be_multiplied_by_an_integer_growth
    self.expects(:sleep).times(1).with(5)
    self.expects(:sleep).times(1).with(15)
    retry_upto(3, :interval => 5, :growth => 3){ @target.foo! }
  end

  def test_grow_for_inverval_between_attempts_can_be_defined_with_a_lambda
    self.expects(:sleep).times(1).with(5)
    self.expects(:sleep).times(1).with(7)
    retry_upto(3, :interval => 5, :growth => lambda{ |t| t + 2 }){ @target.foo! }
  end

  # exceptions

  def test_by_default_any_exception_gets_captured_if_there_are_attempts_left
    retry_upto(3){ @target.foo! }
    assert true # if we reach this no exception was raised out of retry_upto
  end

  def test_the_last_attempt_does_not_capture_the_exception
    assert_raises(FooError) do
      retry_upto(2){ @target.foo! }
    end
  end

  def test_a_specified_exception_will_be_captured_between_attempts
    retry_upto(3, :rescue => FooError){ @target.foo! }
    assert true # if we reach this no exception was raised out of retry_upto
  end

  def test_several_specified_exceptions_will_be_captured_between_attempts
    retry_upto(3, :rescue => [FooError, BarError]){ @target.foo! }
    retry_upto(3, :rescue => [FooError, BarError]){ @target.bar! }
    assert true # if we reach this no exception was raised out of retry_upto
  end

  def test_the_last_attempt_does_not_capture_the_specified_exception
    assert_raises(FooError) do
      retry_upto(2, :rescue => FooError){ @target.foo! }
    end
  end

  def test_a_exception_different_from_the_specified_one_will_not_be_captured_between_attempts
    assert_raises(FooError) do
      retry_upto(3, :rescue => ZeroDivisionError){ @target.foo! }
    end
  end

end