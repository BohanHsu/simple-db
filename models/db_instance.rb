#require 'rbtree'
require 'set'

class DataBaseInstance
  attr_accessor :db_hash, :reverse_hash

  def initialze
    @db_hash = {}
    @reverse_hash = {}
  end

  def set_operation(key, value)
    #raise 'err: key #{key} is NULL' if key.nil?

    # remove from reverse_hash
    if @db_hash.has_key?(key)
      old_value = @db_hash[key]
      @reverse_hash[old_value].delete(key)
    end

    @db_hash[key] = value

    if !@reverse_hash.has_key?(value)
      @reverse_hash[value] = Set.new
    end

    @reverse_hash[value] << key
  end

  def get_operation(key)
    @db_hash[key]
  end

  def unset_operation(key)
    if @db_hash.has_key?(key)
      old_value = @db_hash[key]

      @db_hash.delete(key)
      key_set = @reverse_hash[old_value]
      key_set.delete(key)
      if key_set.empty?
        @reverse_hash.delete(old_value)
      end
    end
  end

  def num_equal_to_operation(value)
    if @reverse_hash.has_key?(value)
      return @reverse_hash[value].size
    end
    0
  end
end
