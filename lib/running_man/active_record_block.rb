module RunningMan
  # Allow simple setup:
  #
  #   RunningMan.setup_on Test::Unit::TestCase, :ActiveRecordBlock
  #
  # See README for instructions on use.
  class ActiveRecordBlock < Block
    module TestClassMethods
      def fixtures(&block)
        test_block = RunningMan::ActiveRecordBlock.new(block)
        setup do
          test_block.run(self)

          # Open a new transaction before running any test.
          ActiveRecord::Base.connection.increment_open_transactions
          ActiveRecord::Base.connection.begin_db_transaction
        end

        teardown do
          # Rollback our transaction, returning our fixtures to a pristine
          # state.
          ActiveRecord::Base.connection.rollback_db_transaction
          ActiveRecord::Base.connection.decrement_open_transactions
          ActiveRecord::Base.clear_active_connections!
        end
      end
    end

    # Clear the database before running the block.
    def run_once(binding)
      clear_database
      super
    end

    # reload any AR instances
    def set_ivar(binding, ivar, value)
      if value.class.respond_to?(:find)
        value = value.class.find(value.id)
      end
      super(binding, ivar, value)
    end

    def clear_database
      conn = ActiveRecord::Base.connection
      conn.tables.each do |table|
        conn.delete "DELETE FROM #{table}"
      end
    end
  end
end