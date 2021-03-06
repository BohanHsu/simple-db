class Transaction
  attr_accessor :set_opt_hash, :delete_keys, :reverse_hash_mask, :db_instance, :next_transaction

  def initialize(db_instance=nil, next_transaction=nil)
    @set_opt_hash = {}
    @delete_keys = {}
    @reverse_hash_mask = {}
    @db_instance = db_instance
    @next_transaction = next_transaction
  end

  def set_operation(key, value)
    old_value = get_operation(key)
    if old_value.nil?
      change_reverse_hash_mask(value, 1)
      if @delete_keys.has_key?(key)
        @delete_keys.delete(key)
      end
    else
      change_reverse_hash_mask(old_value, -1)
      change_reverse_hash_mask(value, 1)
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
      change_reverse_hash_mask(old_value, -1)
    end
    @delete_keys[key] = true
  end

  def num_equal_to_operation(value)
    if @db_instance.nil? && !@next_transaction.nil?
      return (@reverse_hash_mask[value] || 0) + (@next_transaction.num_equal_to_operation(value))
    else
      return (@reverse_hash_mask[value] || 0) + (@db_instance.num_equal_to_operation(value) || 0)
    end
  end

  def commit
    db_instance = nil
    if @db_instance.nil? && !@next_transaction.nil?
      db_instance = @next_transaction.commit
    else
      db_instance = @db_instance
    end

    @set_opt_hash.each do |k, v|
      db_instance.db_hash[k] = v
    end

    @delete_keys.each do |k, v|
      db_instance.db_hash.delete(k)
    end

    @reverse_hash_mask.each do |k, v|
      if !db_instance.reverse_hash.has_key?(k)
        db_instance.reverse_hash[k] = 0
      end

      db_instance.reverse_hash[k] += v

      if db_instance.reverse_hash[k] == 0
        db_instance.reverse_hash.delete(k)
      end
    end

    return db_instance
  end

  def rollback
    return @next_transaction
  end

  def change_reverse_hash_mask(key, value)
    if !@reverse_hash_mask.has_key?(key)
      @reverse_hash_mask[key] = 0
    end

    @reverse_hash_mask[key] += value

    if @reverse_hash_mask[key] == 0
      @reverse_hash_mask.delete(key)
    end
  end
end
