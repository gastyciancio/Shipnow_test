require "test_helper"

class StorageTest < ActiveSupport::TestCase
  def setup
    @storage = Storage.create(name: 'Main Storage')
  end

  test 'should be valid with valid attributes' do
    assert @storage.valid?
  end

  test 'should not be valid without a name' do
    @storage.name = nil
    assert_not @storage.valid?
  end

  test 'should have many orders' do
    assert_respond_to @storage, :orders
  end

  test 'should have many stocks' do
    assert_respond_to @storage, :stocks
  end
end
