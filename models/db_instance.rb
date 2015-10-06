class DataBaseInstance
  attr_accessor :db_hash, :reverse_hash

  def initialize
    @db_hash = {}
    @reverse_hash = {}
  end

  def set_operation(key, value)
    if @db_hash.has_key?(key)
      old_value = @db_hash[key]
      @reverse_hash[old_value] -= 1
    end

    @db_hash[key] = value

    if !@reverse_hash.has_key?(value)
      @reverse_hash[value] = 0
    end

    @reverse_hash[value] += 1
  end

  def get_operation(key)
    @db_hash[key]
  end

  def unset_operation(key)
    if @db_hash.has_key?(key)
      old_value = @db_hash[key]

      @db_hash.delete(key)
      @reverse_hash[old_value] -= 1
      if @reverse_hash[old_value] == 0
        @reverse_hash.delete(old_value)
      end
    end
  end

  def num_equal_to_operation(value)
    if @reverse_hash.has_key?(value)
      return @reverse_hash[value]
    end
    0
  end
end
