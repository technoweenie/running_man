require 'test/unit'
require 'rubygems'
require 'running_man'

RunningMan.setup_on Test::Unit::TestCase, :ActiveRecordBlock

class Test::Unit::TestCase
  def self.setup(&block)
    define_method(:setup, &block)
  end

  def self.teardown(&block)
    define_method(:teardown, &block)
  end
end

begin
  require 'ruby-debug'
  Debugger.start
rescue LoadError
end