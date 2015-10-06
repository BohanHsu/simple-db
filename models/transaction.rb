class Transaction
  attr_accessor :set_opt_hash, :delete_keys, :reverse_hash_shadow, :db_instance, :next_transaction
  def initialize(db_instance=nil, next_transaction=nil)
    @set_opt_hash = {}
    @delete_keys = {}
    @reverse_hash_shadow = {}
    @db_instance = db_instance
    @next_transaction = next_transaction
  end

  def set_operation(key, value)
    old_value = get_operation(key)
    if old_value.nil?
      change_reverse_hash_shadow(value, 1)
      if @delete_keys.has_key?(key)
        @delete_keys.delete(key)
      end
    else
      change_reverse_hash_shadow(old_value, -1)
      change_reverse_hash_shadow(value, 1)
    end
    @set_opt_hash[key] = value
  end


  def get_operation(key)
    if @set_opt_hash.has_key?(key)
      return @set_opt_hash[key]
    elsif @delete_keys.has_key?(key)
      return nil
    else
      if @db_instance.nil? && !@next_transaction.nil?
        return @next_transaction.get_operation(key)
      else
        return @db_instance.get_operation(key)
      end
    end
    return nil
  end

  def unset_operation(key)
    old_value = get_operation(key)
    if @set_opt_hash.has_key?(key)
      @set_opt_hash.delete(key)
    end

    if !old_value.nil?
      change_reverse_hash_shadow(old_value, -1)
    end
    @delete_keys[key] = true
  end

  def num_equal_to_operation(value)
    if @db_instance.nil? && !@next_transaction.nil?
      return (@reverse_hash_shadow[value] || 0) + (@next_transaction.num_equal_to_operation(value))
    else
      return (@reverse_hash_shadow[value] || 0) + (@db_instance.num_equal_to_operation(value) || 0)
    end
  end

  def commit
    raise 'unimplemented!!!'
  end

  def rollback
    raise 'unimplemented!!!'
  end

  def change_reverse_hash_shadow(key, value)
    if !@reverse_hash_shadow.has_key?(key)
      @reverse_hash_shadow[key] = 0
    end

    @reverse_hash_shadow[key] += value

    if @reverse_hash_shadow[key] == 0
      @reverse_hash_shadow.delete(key)
    end
  end
end
