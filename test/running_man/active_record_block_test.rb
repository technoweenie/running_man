require File.join(File.dirname(__FILE__), '..', 'test_helper')

begin
  RunningMan::ActiveRecordBlock

  require 'active_record'
  require 'active_record/version'
  ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => ':memory:'
  ActiveRecord::Base.connection.create_table :test_models do |t|
    t.string :name
  end

class ActiveRecordBlockTest < Test::Unit::TestCase
  class TestModel < ActiveRecord::Base
  end

  class << self
    attr_accessor :block_calls
  end
  self.block_calls = 0

  fixtures do
    ActiveRecordBlockTest.block_calls += 1
    @test = ActiveRecordBlockTest::TestModel.create! :name => 'foo'
  end

  def test_sets_ivar_from_block
    check_values
    assert_equal 'foo', @test.name
  end

  def test_rollbacks
    check_values
    @test.update_attribute :name, 'bar'
    TestModel.create!
  end

  def test_rollbacks_2
    check_values
    @test.update_attribute :name, 'bar'
    TestModel.create!
  end

  def test_rollbacks_3
    check_values
    @test.update_attribute :name, 'bar'
    TestModel.create!
  end

  # since the primitive #setup and #teardown blocks only allow one set per
  # class, do the checks here
  def check_values
    assert_equal 'foo', @test.name
    assert_equal 1,     TestModel.count
    assert_equal 1,     self.class.block_calls
  end
end

puts "Running ActiveRecord v#{ActiveRecord::VERSION::STRING} tests..."

rescue LoadError
  puts $!
  puts "skipping ActiveRecord tests...  gem install activerecord sqlite3-ruby"
end