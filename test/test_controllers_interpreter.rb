require 'minitest/autorun'
require './controllers/interpreter'
require './controllers/database'

describe 'Interpreter' do
  before do
    @database = Database.new
    @interpreter = Interpreter.new(@database)
  end

  it 'should set' do
    result = @interpreter.string_to_action('set ex 10')
    result.must_equal(nil)
    @database.get_operation('ex').must_equal(10)
  end

  it 'should get' do
    result = @interpreter.string_to_action('set ex 10')
    result.must_equal(nil)
    @database.get_operation('ex').must_equal(10)
    result = @interpreter.string_to_action('get ex')
    result.must_equal("10")
  end

  it 'should unset' do
    result = @interpreter.string_to_action('set ex 10')
    result = @interpreter.string_to_action('unset ex ')
    result = @interpreter.string_to_action('get ex')
    result.must_equal("NULL")
  end

  it 'should query number of value' do
    result = @interpreter.string_to_action('set a 10')
    result = @interpreter.string_to_action('set b 10')
    result = @interpreter.string_to_action('numequalto 10')
    result.must_equal('2')
    result = @interpreter.string_to_action('numequalto 20')
    result.must_equal('0')
  end

  it 'should able to begin and rollback transaction' do
    result = @interpreter.string_to_action('begin')
    result.must_equal(nil)
    result = @interpreter.string_to_action('set a 10')
    result = @interpreter.string_to_action('get a')
    result.must_equal('10')
    result = @interpreter.string_to_action('rollback')
    result = @interpreter.string_to_action('get a')
    result.must_equal('NULL')
  end

  it 'should only rollback current transaction' do
    result = @interpreter.string_to_action('begin')
    result = @interpreter.string_to_action('set a 10')
    result = @interpreter.string_to_action('get a')
    result.must_equal('10')
    result = @interpreter.string_to_action('begin')
    result = @interpreter.string_to_action('set b 20')
    result = @interpreter.string_to_action('get a')
    result.must_equal('10')
    result = @interpreter.string_to_action('get b')
    result.must_equal('20')
    result = @interpreter.string_to_action('rollback')
    result = @interpreter.string_to_action('get a')
    result.must_equal('10')
    result = @interpreter.string_to_action('get b')
    result.must_equal('NULL')
  end

  it 'should able to commit transaction' do
    result = @interpreter.string_to_action('begin')
    result = @interpreter.string_to_action('set a 10')
    result = @interpreter.string_to_action('get a 10')
    result.must_equal('10')
    result = @interpreter.string_to_action('commit')
    result = @interpreter.string_to_action('get a 10')
    result.must_equal('10')
  end

  it 'should commit multi transaction' do
    result = @interpreter.string_to_action('begin')
    result = @interpreter.string_to_action('set a 10')
    result = @interpreter.string_to_action('get a')
    result.must_equal('10')
    result = @interpreter.string_to_action('begin')
    result = @interpreter.string_to_action('set b 20')
    result = @interpreter.string_to_action('get a')
    result.must_equal('10')
    result = @interpreter.string_to_action('get b')
    result.must_equal('20')
    result = @interpreter.string_to_action('commit')
    result.must_equal(nil)
    result = @interpreter.string_to_action('get a')
    result.must_equal('10')
    result = @interpreter.string_to_action('get b')
    result.must_equal('20')
    result = @interpreter.string_to_action('commit')
    result.must_equal('NO TRANSACTION')
    result = @interpreter.string_to_action('rollback')
    result.must_equal('NO TRANSACTION')
  end
end
