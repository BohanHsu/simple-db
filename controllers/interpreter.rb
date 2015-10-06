class Interpreter
  def initialize(database)
    @database = database
  end

  def string_to_action(str)
    argv = str.split(/\s+/)
    action = argv[0].upcase
    case
    when action == 'SET'
      key = argv[1]
      value = argv[2]
      if value.to_i.to_s == value
        value = value.to_i
      end
      @database.set_operation(key, value)
      return nil
    when action == 'GET'
      key = argv[1]
      result = @database.get_operation(key)
      return result_to_string(result, action)
    when action == 'UNSET'
      key = argv[1]
      result = @database.unset_operation(key)
      #return result_to_string(result, action)
      return nil
    when action == 'NUMEQUALTO'
      value = argv[1]
      if value.to_i.to_s == value
        value = value.to_i
      end
      result = @database.num_equal_to_operation(value)
      return result_to_string(result, action)
    when action == 'BEGIN'
      @database.open_transaction
      return nil
    when action == 'ROLLBACK'
      result = @database.rollback_transaction
      return result_to_string(result, action)
    when action == 'COMMIT'
      result = @database.commit_transaction
      return result_to_string(result, action)
    end
  end

  def result_to_string(result, action)
    case
    when action == 'GET'
      if result.nil?
        return 'NULL'
      else
        return result.to_s
      end
    #when action == 'UNSET'
    when action == 'NUMEQUALTO'
      return result.to_s
    when action == 'ROLLBACK'
      if !result
        return 'NO TRANSACTION'
      else
        return nil
      end
    when action == 'COMMIT'
      if !result
        return 'NO TRANSACTION'
      else
        return nil
      end
    end
  end
end
