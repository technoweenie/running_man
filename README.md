# RunningMan

Provides a simple way of setting up setup/teardown blocks that execute just
once for the entire test case.

    class MyTest < Test::Unit::TestCase
      class << self
        attr_accessor :block
      end
      
      self.block = RunningMan::Block.new do
        # something expensive
      end
      
      def setup
        self.class.block.run(self)
      end
    end

This looks much better in something like ActiveSupport::TestCase, where a
`#setup` method takes a block.

    class MyTest < ActiveSupport::TestCase
      block = RunningMan::Block.new do
        # something expensive
      end
      
      setup { block.run(self) }
    end

You can also extend your test case class with helper methods to make this 
look nicer.

    RunningMan.setup_on ActiveSupport::TestCase
    class MyTest < ActiveSupport::TestCase
      setup_once do
        # something expensive
      end
    end

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don’t break it in a future version 
  unintentionally.
* Commit, do not mess with rakefile, version, or history. (if you want to have 
  your own version, that is fine but bump version in a commit by itself I can 
  ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright © 2010 rick. See LICENSE for details.