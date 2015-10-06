require '../models/db_instance'

class Database
  def initialize
    @database_instance = DataBaseInstance.new
    @transactions = []
  end

  def open_transaction
  end

  def commit_transaction
  end

  def commit_transaction
  end

  def get_current_db_instance
  end
end
