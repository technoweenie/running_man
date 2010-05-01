require File.join(File.dirname(__FILE__), '..', 'test_helper')

class BlockTest < Test::Unit::TestCase
  class << self
    attr_accessor :block,  :block_calls
  end

  self.block_calls = 0
  self.block = RunningMan::Block.new do
    @a = 1
    BlockTest.block_calls += 1
  end

  def setup
    @b = 2
    self.class.block.run(self)
  end

  def teardown
    assert_equal 1, self.class.block_calls
  end

  def test_sets_ivar_from_block
    assert_equal 1, @a
  end

  def test_sets_ivar_from_setup
    assert_equal 2, @b
  end
end