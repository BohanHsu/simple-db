require 'minitest/autorun'
require '../models/db_instance'

describe 'DataBaseInstance' do
  before do
    @db_instance = DataBaseInstance.new
  end

  it 'should set value to key' do
    @db_instance.set_operation('ex', 10)
    @db_instance.db_hash.size.must_equal(1)
    @db_instance.db_hash['ex'].must_equal(10)
    @db_instance.reverse_hash.size.must_equal(1)
    @db_instance.reverse_hash[10].must_equal(1)
  end

  it 'should get value by key' do
    @db_instance.set_operation('ex', 10)
    @db_instance.get_operation('ex').must_equal(10)
    @db_instance.db_hash.size.must_equal(1)
    @db_instance.db_hash['ex'].must_equal(10)
    @db_instance.reverse_hash.size.must_equal(1)
    @db_instance.reverse_hash[10].must_equal(1)
  end

  it 'should unset seted value' do
    @db_instance.set_operation('ex', 10)
    @db_instance.unset_operation('ex')

    @db_instance.db_hash.size.must_equal(0)
    @db_instance.db_hash.has_key?('ex').must_equal(false)
    @db_instance.reverse_hash.size.must_equal(0)
    @db_instance.reverse_hash.has_key?(10).must_equal(false)
  end

  it 'should return num of key equals to value' do
    @db_instance.set_operation('ex', 10)
    @db_instance.reverse_hash[10].must_equal(1)
    @db_instance.set_operation('eax', 10)
    @db_instance.reverse_hash[10].must_equal(2)
    @db_instance.set_operation('ebx', 10)
    @db_instance.reverse_hash[10].must_equal(3)
    @db_instance.set_operation('eax', 15)
    @db_instance.reverse_hash[10].must_equal(2)
    @db_instance.set_operation('eax', 10)
    @db_instance.reverse_hash[10].must_equal(3)
  end
end
