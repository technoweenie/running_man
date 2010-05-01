require File.join(File.dirname(__FILE__), '..', 'test_helper')

class BlockHelperTest < Test::Unit::TestCase
  class << self
    attr_accessor :block_calls
  end
  self.block_calls = 0

  setup_once do
    @a = 1
    BlockHelperTest.block_calls += 1
  end

  def teardown
    assert_equal 1, self.class.block_calls
  end

  def test_sets_ivar_from_block
    assert_equal 1, @a
  end

  # checks that block_calls is not incremented again
  def test_again
  end
end