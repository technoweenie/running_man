require 'test/unit'
require 'running_man'

RunningMan.setup_on Test::Unit::TestCase

class Test::Unit::TestCase
  def self.setup(&block)
    define_method(:setup, &block)
  end
end