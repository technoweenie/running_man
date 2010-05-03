require File.join(File.dirname(__FILE__), '..', 'test_helper')

class BlockHelperTest < Test::Unit::TestCase
  class << self
    attr_accessor :block_calls, :test_calls
  end
  self.block_calls = self.test_calls = 0

  original_string = 'abc'.freeze

  setup_once do
    @a = original_string
    self.class.block_calls += 1
  end

  teardown_once do
    assert_equal original_string, @a
    assert_equal original_string.object_id, @a.object_id
    assert_equal 1, self.class.block_calls
    assert_equal 2, self.class.test_calls
  end

  def test_sets_ivar_from_block
    self.class.test_calls += 1
    assert_equal 'abc', @a
  end

  # checks that block_calls is not incremented again
  def test_again
    self.class.test_calls += 1
  end
end