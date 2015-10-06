require './models/db_instance'
require './models/transaction'

class Database
  def initialize
    @db_instance = DataBaseInstance.new
    @transaction = nil
  end

  def open_transaction
    if @transaction.nil?
      @transaction = Transaction.new(@db_instance, nil)
    else
      @transaction = Transaction.new(nil, @transaction)
    end
  end

  def commit_transaction
    if @transaction
      @db_instance = @transaction.commit
      @transaction = nil
      return true
    else
      return false
    end
  end

  def rollback_transaction
    if @transaction
      @transaction = @transaction.rollback
      return true
    else
      return false
    end
  end

  def set_operation(key, value)
    transaction = @transaction
    if transaction
      transaction.set_operation(key, value)
    else
      transaction = Transaction.new(@db_instance, nil)
      transaction.set_operation(key, value)
      @db_instance = transaction.commit
    end
    return true
  end

  def get_operation(key)
    transaction = @transaction
    if transaction
      return transaction.get_operation(key)
    else
      return @db_instance.get_operation(key)
    end
  end

  def unset_operation(key)
    transaction = @transaction
    if transaction
      transaction.unset_operation(key)
    else
      transaction = Transaction.new(@db_instance, nil)
      transaction.unset_operation(key)
      @db_instance = transaction.commit
    end
  end

  def num_equal_to_operation(value)
    transaction = @transaction
    if transaction
      return transaction.num_equal_to_operation(value)
    else
      return @db_instance.num_equal_to_operation(value)
    end
  end

  def end_operation
  end
end
