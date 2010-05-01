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

## ActiveRecord!

The use case for RunningMan is for database testing in my Rails apps.
RunningMan gives me a setup where on each test case, we:

1. Clear the database
2. Load the fixtures
3. Run the tests

It's not entirely unlike Rails' default fixture behavior, but there are a few 
important subtleties:

1. Fixtures are not loaded into the DB for each test - instead they
   are loaded once for each test class and shared amongst the
   tests.
2. Each test class has its own set of fixtures. Adding or removing
   fixtures to a test class will not break other tests in strange
   and mysterious ways.

This has been tested on Ruby 1.8.7/ActiveRecord 2.2 and 
Ruby 1.9/ActiveRecord 3.0 beta 3.

    RunningMan.setup_on ActiveSupport::TestCase, :ActiveRecordBlock
    class MyTest < ActiveSupport::TestCase
      fixtures do
        @post = Post.make # <3 Machinist
      end

      test "check something on post" do
        assert_equal 'foo', @post.title
      end

      test "delete post" do
        @post.destroy
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