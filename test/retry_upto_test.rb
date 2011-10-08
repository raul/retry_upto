require './test/test_helper'

class Retry_uptoTest < MiniTest::Unit::TestCase

  class FooError < Exception; end

  # raises ZeroDivisionError in the two first hits
  class Target
    attr_accessor :hits
    def initialize; @hits = 0; end

    def hit!
      @hits += 1
      raise FooError if @hits < 3
    end
  end

  def setup
    @target = Target.new
  end

  # number of attempts

  def test_retries_one_time_by_default_without_capturing_the_exception
    assert_raises(FooError) do
      retry_upto{ @target.hit! }
    end
    assert_equal 1, @target.hits
  end

  def test_retries_the_desired_number_of_attempts
    retry_upto(3){ @target.hit! }
    assert_equal 3, @target.hits
  end

  # interval between attempts

  def test_there_is_no_interval_between_attempts_by_default
    self.expects(:sleep).times(2).with(0).returns(nil)
    retry_upto(3){ @target.hit! }
  end

  def test_interval_between_attempts_can_be_customized
    self.expects(:sleep).times(2).with(5).returns(nil)
    retry_upto(3, :interval => 5){ @target.hit! }
  end

  # interval growth between attempts

  def test_inverval_can_be_multiplied_by_an_integer_growth
    self.expects(:sleep).times(1).with(5)
    self.expects(:sleep).times(1).with(15)
    retry_upto(3, :interval => 5, :growth => 3){ @target.hit! }
  end

  def test_grow_for_inverval_between_attempts_can_be_defined_with_a_lambda
    self.expects(:sleep).times(1).with(5)
    self.expects(:sleep).times(1).with(7)
    retry_upto(3, :interval => 5, :growth => lambda{ |t| t + 2 }){ @target.hit! }
  end

  # exceptions

  def test_by_default_any_exception_gets_captured_if_there_are_attempts_left
    retry_upto(3){ @target.hit! }
    assert true # if we reach this no exception was raised out of retry_upto
  end

  def test_the_last_attempt_does_not_capture_the_exception
    assert_raises(FooError) do
      retry_upto(2){ @target.hit! }
    end
  end

  def test_a_specified_exception_will_be_captured_between_attempts
    retry_upto(3, :rescue => FooError){ @target.hit! }
    assert true # if we reach this no exception was raised out of retry_upto
  end

  def test_the_last_attempt_does_not_capture_the_specified_exception
    assert_raises(FooError) do
      retry_upto(2, :rescue => FooError){ @target.hit! }
    end
  end

  def test_a_exception_different_from_the_specified_one_will_not_be_captured_between_attempts
    assert_raises(FooError) do
      retry_upto(3, :rescue => ZeroDivisionError){ @target.hit! }
    end
  end

end