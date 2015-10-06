require 'minitest/autorun'
require '../models/db_instance'
require '../models/transaction'

describe 'Transaction' do
  before do
    @db_instance = DataBaseInstance.new
    @db_instance.set_operation('eax', 10)
    @db_instance.set_operation('ebx', 10)
    @db_instance.set_operation('ecx', 20)

    @transaction1 = Transaction.new(@db_instance, nil)
    @transaction2 = Transaction.new(nil, @transaction1)
  end

  it 'should get value of key' do
    @transaction1.get_operation('eax').must_equal(10)
    @transaction1.get_operation('ebx').must_equal(10)
    @transaction1.get_operation('ecx').must_equal(20)

    @transaction1.set_operation('eax', 30)
    @transaction1.get_operation('eax').must_equal(30)

    @transaction1.unset_operation('eax')
    @transaction1.get_operation('eax').must_equal(nil)

    @transaction2.get_operation('eax').must_equal(nil)
    @transaction2.get_operation('ebx').must_equal(10)
    @transaction2.get_operation('ecx').must_equal(20)

    @transaction2.set_operation('ebx', 30)
    @transaction2.get_operation('ebx').must_equal(30)

    @transaction2.unset_operation('ebx')
    @transaction2.get_operation('ebx').must_equal(nil)
  end

  it 'should set key value in transaction' do
    @transaction1.num_equal_to_operation(10).must_equal(2)
    @transaction1.num_equal_to_operation(20).must_equal(1)

    @transaction2.num_equal_to_operation(10).must_equal(2)
    @transaction2.num_equal_to_operation(20).must_equal(1)

    @transaction1.set_operation('eax', 30)
    @transaction1.reverse_hash_shadow[10].must_equal(-1)
    @transaction1.reverse_hash_shadow[30].must_equal(1)
    @transaction1.num_equal_to_operation(10).must_equal(1)
    @transaction1.num_equal_to_operation(30).must_equal(1)

    @transaction2.set_operation('eax', 40)
    @transaction2.reverse_hash_shadow[30].must_equal(-1)
    @transaction2.reverse_hash_shadow[40].must_equal(1)
    @transaction2.num_equal_to_operation(40).must_equal(1)
    @transaction2.num_equal_to_operation(30).must_equal(0)
    @transaction2.num_equal_to_operation(20).must_equal(1)
    @transaction2.num_equal_to_operation(10).must_equal(1)
  end

  it 'should unset key value in transaction' do
    @transaction1.unset_operation('eax')
    @transaction1.reverse_hash_shadow[10] = -1
    @transaction1.num_equal_to_operation(10).must_equal(1)
    @transaction2.unset_operation('ebx')
    @transaction2.reverse_hash_shadow[10] = -1
    @transaction2.num_equal_to_operation(10).must_equal(0)
  end

  it 'should work when unset and set in same transaction' do
    @transaction1.set_operation('eax', 30)
    @transaction1.reverse_hash_shadow[30].must_equal(1)
    @transaction1.num_equal_to_operation(30).must_equal(1)
    @transaction1.unset_operation('eax')
    @transaction1.set_opt_hash['eax'].must_equal(nil)
    @transaction1.reverse_hash_shadow[30].must_equal(nil)
    @transaction1.num_equal_to_operation(30).must_equal(0)
    @transaction1.set_operation('eax', 30)
    @transaction1.reverse_hash_shadow[30].must_equal(1)
    @transaction1.num_equal_to_operation(30).must_equal(1)

    @transaction2.set_operation('ebx', 40)
    @transaction2.reverse_hash_shadow[40].must_equal(1)
    @transaction2.num_equal_to_operation(40).must_equal(1)
    @transaction2.unset_operation('ebx')
    @transaction2.set_opt_hash['ebx'].must_equal(nil)
    @transaction2.reverse_hash_shadow[40].must_equal(nil)
    @transaction2.num_equal_to_operation(40).must_equal(0)
    @transaction2.set_operation('ebx', 40)
    @transaction2.reverse_hash_shadow[40].must_equal(1)
    @transaction2.num_equal_to_operation(40).must_equal(1)
  end

  it 'should work when unset and set in different transaction' do
    @transaction1.reverse_hash_shadow[10].must_equal(nil)
    @transaction1.unset_operation('eax')
    @transaction1.reverse_hash_shadow[10].must_equal(-1)
    @transaction1.num_equal_to_operation(10).must_equal(1)
    @transaction1.get_operation('eax').must_equal(nil)
    @transaction2.set_operation('eax', 30)
    @transaction2.reverse_hash_shadow[10].must_equal(nil)
    @transaction2.reverse_hash_shadow[30].must_equal(1)
    @transaction2.get_operation('eax').must_equal(30)

    @transaction1.set_operation('ebx', 40)
    @transaction1.reverse_hash_shadow[10].must_equal(-2)
    @transaction1.reverse_hash_shadow[40].must_equal(1)
    @transaction1.num_equal_to_operation(10).must_equal(0)
    @transaction1.get_operation('ebx').must_equal(40)
    @transaction2.unset_operation('ebx')
    @transaction2.reverse_hash_shadow[40].must_equal(-1)
    @transaction2.num_equal_to_operation(40).must_equal(0)
    @transaction2.get_operation('ebx').must_equal(nil)
  end
end
