$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

module RunningMan
  VERSION = '0.3.9'

  # Public: Sets up any helper class methods in TestClassMethods on the 
  # specified test case class.
  #
  # Examples
  #
  #   # extends test/unit with RunningMan::Block::TestClassMethods
  #   RunningMan::Block.setup_on Test::Unit::TestCase
  #
  #   # extends ActiveSupport::TestCase
  #   RunningMan::Block.setup_on ActiveSupport::TestCase
  #
  #   # extends test/unit with RunningMan::Block::TestClassMethods and
  #   # RunningMan::FooBlock::TestClassMethods
  #   RunningMan::Block.setup_on Test::Unit::TestCase, :FooBlock
  #
  #   # extends test/unit with RunningMan::Block::TestClassMethods and 
  #   # MyBlock::TestClassMethods
  #   RunningMan::Block.setup_on Test::Unit::TestCase, MyBlock
  #
  # source   - The class to extend.  Usually Test::Unit::TestCase.
  # *klasses - Optional Array of RunningMan::Block subclasses or Symbols.
  #
  # Returns nothing.
  def self.setup_on(source, *klasses)
    klasses.unshift(Block)
    klasses.uniq!
    klasses.each do |klass|
      if klass.is_a?(Symbol)
        klass = RunningMan.const_get(klass)
      end
      if klass.const_defined?(:TestClassMethods)
        source.extend klass.const_get(:TestClassMethods)
      end
    end
  end

  autoload :ActiveRecordBlock, 'running_man/active_record_block'
end

require 'running_man/block'
